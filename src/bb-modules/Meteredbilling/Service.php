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
        if ($model->product_id == $productId){
            return $model;
        }
        return null;
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
        return $this->cost($lastUsage, $currentTime);

    }

    public function calculateProductUsageCost(\Model_MeteredUsage $model)
    {
        $lastUsage = $this->findLastLoggedProductUsage($model->client_id, $model->order_id, $model->product_id);
        return $this->cost($lastUsage, $model->created_at);

    }

    public function cost($model, $currentTime)
    {
        if (!$model instanceof \Model_MeteredUsage){
            return 0.00000000;
        }
        $intervalInHours = abs(strtotime($model->created_at) - strtotime($currentTime) ) / 3600;
        $productService = $this->di['mod_service']('Product');
        $unitPrice = $productService->getMeteredPrice($model->product_id);

        return $unitPrice * $intervalInHours;
    }

    /**
     * Save \Model_MeteredUsage $model
     * @return bool
     */
    public function save(\Model_MeteredUsage $model)
    {
        $model->cost = $this->calculateProductUsageCost($model);
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
        $productConfig = $this->di['tools']->decodeJ($productModel ->config);


        $model = $this->di['db']->dispense('MeteredUsage');
        $model->plan_id = isset($productConfig['hosting_plan_id']) ? $productConfig['hosting_plan_id'] : null;;
        $model->client_id = $clientOrder->client_id;
        $model->order_id = $clientOrder->id;
        $model->product_id = $productModel->id;
        $model->created_at = date('c');
        return $model;
    }

    /**
     * Get client's unbilled metered usage
     * @param int $clientId
     * @return array
     */
    public function getUnbilledUsage($clientId)
    {
        return $this->di['db']->find('MeteredBilling', 'client_id = :client_id AND invoice_id = 0', array(':client_id' => $clientId)) ;
    }

    public function getOrderUsageTotalCost(\Model_ClientOrder $clientOrder)
    {
        $sql = 'SELECT sum(metered_usage.cost)
                FROM metered_usage
                  LEFT JOIN invoice on metered_usage.invoice_id = invoice.id AND invoice.status = :invoice_status
                WHERE metered_usage.order_id = :order_id';
        $bindings = array(
            ':order_id' => $clientOrder->id,
            ':invoice_status' =>\Model_Invoice::STATUS_UNPAID,
        );

        $usedCost = $this->di['db']->getCell($sql, $bindings);
        return $usedCost + $this->calculateCurrentUsageCost(date('c'), $clientOrder->client_id, $clientOrder->id);
    }
}
