<?php
/**
 * BoxBilling
 *
 * @copyright BoxBilling, Inc (http://www.boxbilling.com)
 * @license   Apache-2.0
 *
 * Copyright BoxBilling, Inc
 * This source file is subject to the Apache-2.0 License that is bundled
 * with this source code in the file LICENSE
 */


namespace Box\Mod\Meteredbilling;

use Box\InjectionAwareInterface;

class Service implements InjectionAwareInterface
{

    private $fractionPrecision = 8;

    /**
     * @var \Box_Di
     */
    protected $di = null;

    /**
     * @param \Box_Di $di
     */
    public function setDi($di)
    {
        $this->di = $di;
    }

    /**
     * @return \Box_Di
     */
    public function getDi()
    {
        return $this->di;
    }

    /**
     * @param int $clientId
     * @param int $orderId
     * @return \Model_MeteredUsage | null
     */
    public function findLastUnbilledUsage($clientId, $orderId)
    {
        $whereStatement = 'client_id = :client_id AND
             order_id = :order_id AND
             invoice_id = 0
             ORDER BY id desc';
        $bindings = array(
            ':client_id' =>  $clientId,
            ':order_id' => $orderId,
        );
        return $model = $this->di['db']->findOne('MeteredUsage', $whereStatement, $bindings);
    }

    public function findLastLoggedProductUsage($clientId, $orderId, $productId)
    {
        $whereStatement = 'client_id = :client_id AND
             order_id = :order_id AND
             invoice_id = 0
             ORDER BY id desc';
        $bindings = array(
            ':client_id' =>  $clientId,
            ':order_id' => $orderId,
        );
        $model = $this->di['db']->findOne('MeteredUsage', $whereStatement, $bindings);
        if (isset($model) && $model->product_id == $productId){
            return $model;
        }
        return null;
    }

    public function findActiveProductUsage($clientId, $orderId, $productId)
    {
        $whereStatement = 'order_id = :order_id AND
             client_id = :client_id AND
             product_id = :product_id AND
             stopped_at is null AND
             invoice_id = 0
             ORDER BY id desc';
        $bindings = array(
            ':client_id' =>  $clientId,
            ':order_id' => $orderId,
            ':product_id' => $productId,
        );
        $model = $this->di['db']->findOne('MeteredUsage', $whereStatement, $bindings);
        return $model;
    }

    public function stopUsage(\Model_MeteredUsage $model)
    {
        $model->stopped_at = date('c');
        return $this->save($model);
    }

    /**
     * Calculate usage cost (timebased)
     * @param string $currentTime
     * @param int $client_id
     * @param int $order_id
     * @return float
     */
    public function calculateCurrentUsageCost($currentTime, $client_id, $order_id)
    {
        $lastUsage = $this->findLastUnbilledUsage($client_id, $order_id);
        return $this->getDuration($lastUsage, $currentTime) * $lastUsage->price;

    }

    public function getDuration($model, $currentTime = null)
    {
        if (!$currentTime){
            return 0;
        }
        return strtotime($currentTime) - strtotime($model->created_at);
    }

    /**
     * Save \Model_MeteredUsage $model
     * @return bool
     */
    public function save(\Model_MeteredUsage $model)
    {
        $model->duration = $this->getDuration($model, $model->stopped_at);
        $this->di['db']->store($model);
        return true;
    }

    /**
     * Create metered usage model
     * @param int $planId
     * @param int $clientId
     * @param int $orderId
     * @param int $productId
     * @return \Model_MeteredUsage
     */
    public function create(\Model_ClientOrder $clientOrder)
    {
        $productModel = $this->di['db']->load('Product', $clientOrder->product_id);
        $productConfig = $this->di['tools']->decodeJ($productModel->config);

        $productService = $this->di['mod_service']('Product');

        $model = $this->di['db']->dispense('MeteredUsage');
        $model->plan_id = isset($productConfig['hosting_plan_id']) ? $productConfig['hosting_plan_id'] : null;;
        $model->client_id = $clientOrder->client_id;
        $model->order_id = $clientOrder->id;
        $model->product_id = $productModel->id;
        $model->price = bcdiv($productService->getMeteredPrice($model->product_id), 3600, $this->fractionPrecision);
        $model->created_at = date('c');
        return $model;
    }

    public function getOrderUsageTotalCost(\Model_ClientOrder $clientOrder)
    {
        $sql = 'SELECT sum(metered_usage.duration * metered_usage.price)
                FROM metered_usage
                  LEFT JOIN invoice on metered_usage.invoice_id = invoice.id
                WHERE metered_usage.order_id = :order_id
                  AND (invoice.status = :invoice_status or metered_usage.invoice_id = 0)';
        $bindings = array(
            ':order_id' => $clientOrder->id,
            ':invoice_status' =>\Model_Invoice::STATUS_UNPAID,
        );
        $usedCost = $this->di['db']->getCell($sql, $bindings);
        if ($clientOrder->status == \Model_ClientOrder::STATUS_ACTIVE){
            return bcadd($usedCost, $this->calculateCurrentUsageCost(date('c'), $clientOrder->client_id, $clientOrder->id), $this->fractionPrecision);
        }
        return bcadd($usedCost, 0, $this->fractionPrecision);
    }

    public function setInvoiceForUsage(\Model_ClientOrder $clientOrder, $invoiceId)
    {
        $sql = 'UPDATE metered_usage
                SET metered_usage.invoice_id = :invoice_id
                WHERE metered_usage.order_id = :order_id
                  AND invoice_id = 0';
        $bindings = array(
            ':order_id' => $clientOrder->id,
            ':invoice_id' => $invoiceId,
        );
        return $this->di['db']->exec($sql, $bindings);
    }

    public function getOrderUsageList(\Model_ClientOrder $clientOrder)
    {
        $sql = 'SELECT metered_usage.*, invoice.serie, invoice.nr, product.title as product_name
                FROM metered_usage
                  LEFT JOIN invoice on metered_usage.invoice_id = invoice.id
                  LEFT JOIN product on metered_usage.product_id = product.id
                WHERE
                  metered_usage.order_id = :order_id AND
                  metered_usage.client_id = :client_id';
        $bindings = array(
            ':order_id' => $clientOrder->id,
            ':client_id' => $clientOrder->client_id,
        );
        $usages = $this->di['db']->getAll($sql, $bindings);

        $elem = array_pop($usages);
        if ($elem['stopped_at'] == '0000-00-00 00:00:00'){
            $elem['stopped_at'] = '';
            $elem['duration'] = strtotime(date('c')) - strtotime($elem['created_at']);
        }
        array_push($usages, $elem);
        return $usages;
    }

    public function generateInvoicesOnFirstDayOfTheMonth()
    {
        if (!$this->isFirstDayOfTheMonth()){
            return -1;
        }
        $sql = 'SELECT order_id
                FROM metered_usage
                WHERE invoice_id == 0
                GROUP BY order_id';
        $invoiceService = $this->di['mod_service']('Invoice');
        $invoicesGenerated = 0;
        foreach($this->di['db']->getAll($sql) as $meteredUsage){
            $orderModel = $this->di['db']->load('ClientOrder', $meteredUsage['order_id']);
            try{
                $invoiceService->generateForOrderWithMeteredBilling($orderModel);
                $invoicesGenerated  ++;
            }
            catch (\Box_Exception $e){
                if ($e->getCode() != 1157){
                    throw $e;
                }
            }
        }
        return $invoicesGenerated;
    }

    public function isFirstDayOfTheMonth()
    {
        if (date('Y-m-01') == date('Y-m-d')){
            return true;
        }
        return false;
    }

    public function suspendOrdersWithUnpaidInvoices()
    {
        $suspendedOrders = 0;
        $mod = $this->di['mod']('meteredbilling');
        $config = $mod->getConfig();

        $days = isset($config['metered_order_suspend']) ? $config['metered_order_suspend'] : 15;

        $sql = 'SELECT metered_usage.order_id, metered_usage.invoice_id
                FROM metered_usage
                  LEFT JOIN client_order on metered_usage.order_id = client_order.id
                  LEFT JOIN invoice on metered_usage.invoice_id = invoice.id
                WHERE metered_usage.invoice_id > 0
                  AND client_order.status = :order_status
                  AND invoice.status = :invoice_status
                  AND invoice.created_at < :invoice_days
                GROUP BY metered_usage.order_id';

        $bindings = array(
            ':order_status' => \Model_ClientOrder::STATUS_ACTIVE,
            ':invoice_status' => \Model_Invoice::STATUS_UNPAID,
            ':invoice_days' => date('c', strtotime("-$days days")),
        );

        $orders = $this->di['db']->getAll($sql, $bindings);

        if (empty($orders)) {
            return -1;
        }

        $orderService = $this->di['mod_service']('Order');
        foreach($orders as $order){
            $orderModel = $this->di['db']->load('ClientOrder', $order['id']);
            $orderService->suspendFromOrder($orderModel, sprintf('Reason: Unpaid invoice#%d', $order['invoice_id']));
            $suspendedOrders ++;
        }
        return $suspendedOrders;
    }


}
