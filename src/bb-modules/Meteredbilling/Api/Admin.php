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

class Admin extends \Api_Abstract
{

    /**
     * Returns total amount of unpaid order usage
     * @param $data - order_id
     * @return bool
     */
    public function get_total_cost($data)
    {
        $required = array(
            'order_id' => 'Missing order id',
        );
        $this->di['validator']->checkRequiredParamsForArray($required, $data);

        $orderModel = $this->di['db']->getExistingModelById('ClientOrder', $data['order_id'], 'Order not found');
        return $this->getService()->getOrderUsageTotalCost($orderModel);
    }

    public function cron_generate_invoices()
    {
        return $this->getService()->generateInvoicesOnFirstDayOfTheMonth();
    }

    public function cron_suspend_orders()
    {
        return $this->getService()->suspendOrdersWithUnpaidInvoices();
    }
}