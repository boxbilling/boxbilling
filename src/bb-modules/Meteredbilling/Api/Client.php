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

namespace Box\Mod\Meteredbilling\Api;

class Client extends \Api_Abstract
{
    /**
     * Returns total amount of unpaid order usage
     * @param $data
     * @return bool
     */
    public function get_total_cost($data)
    {
        $required = array(
            'order_id' => 'Missing order id',
        );
        $this->di['validator']->checkRequiredParamsForArray($required, $data);
        $orderModel = $this->di['db']->getExistingModelById('ClientOrder', $data['order_id'], 'Order not found');

        if ($orderModel->client_id != $this->getIdentity()->id){
            throw new \Box_Exception('Order not found', array(), 5547);
        }

        return $this->getService()->getOrderUsageTotalCost($orderModel);
    }

    public function get_order_usage_list($data)
    {
        $required = array(
            'order_id' => 'Missing order id',
        );
        $this->di['validator']->checkRequiredParamsForArray($required, $data);
        $orderModel = $this->di['db']->getExistingModelById('ClientOrder', $data['order_id'], 'Order not found');

        if ($orderModel->client_id != $this->getIdentity()->id){
            throw new \Box_Exception('Order not found', array(), 5548);
        }

        return $this->getService()->getOrderUsageList($orderModel);
    }
}