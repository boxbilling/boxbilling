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

    public function findLastUnbilledUsage($clientId, $orderId)
    {
        $whereStatement = 'client_id = :client_id AND
             order_id = :order_id AND
             invoice_id = 0 ';
        $bindings = array(
            ':client_id' =>  $clientId,
            ':order_id' => $orderId,
        );
        return $model = $this->di['db']->findOne('MeteredUsage', $whereStatement, $bindings);
    }

    public function calculateUsageCost($currentTime, \Model_MeteredUsage $newUsage)
    {
        $lastUsage = $this->findLastUnbilledUsage($newUsage->client_id, $newUsage->order_id);
        if (!$lastUsage instanceof \Model_MeteredUsage){
            return 0.00000000;
        }

        $intervalInHours = abs(strtotime($lastUsage->created_at) - strtotime($currentTime) ) / 3600;
        $productService = $this->di['mod_service']('Product');
        $unitPrice = $productService->getMeteredPrice($newUsage->product_id);

        return $unitPrice * $intervalInHours;

    }

    public function logUsage($planId, $clientId, $orderId, $productId)
    {
        $model = $this->di['db']->dispense('MeteredUsage');
        $creationTime = date('c');

        $model->plan_id = $planId;
        $model->client_id = $clientId;
        $model->order_id = $orderId;
        $model->product_id = $productId;
        $model->invoice_id = 0;
        $model->cost = $this->calculateUsageCost($creationTime, $model);
        $model->created_at = $creationTime;

        $this->di['db']->store($model);

        return true;
    }

    public function getUnbilledUsage($clientId)
    {
        return $this->di['db']->find('MeteredBilling', 'client_id = :client_id AND invoice_id = 0', array(':client_id' => $clientId)) ;
    }
}
