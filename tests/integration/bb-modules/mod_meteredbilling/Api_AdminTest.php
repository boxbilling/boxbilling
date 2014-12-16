<?php
/**
 * @group Core
 */
class Api_Admin_MeteredbillingTest extends BBDbApiTestCase
{
    protected $_initialSeedFile = 'meteredbilling.xml';

    public function testget_total_cost()
    {
        $data['client_id']      = 1;
        $data['product_id']     = 1;
        $data['invoice_option'] = 'no-invoice';
        $data['activate'] = 1;
        $data['config'] = array('domain'=>array('action'=>'owndomain', 'owndomain_sld'=>'vm', 'owndomain_tld'=>'.com'));

        $id = $this->api_admin->order_create($data);

        $lastUsage = $this->di['db']->load('MeteredUsage', 3);
        $loggedTotal = 1.23896571; // From fixtures

        $fractionPrecision = 8;
        $diff = (strtotime(date('c')) - strtotime($lastUsage->created_at));
        $currentUsage = bcmul($diff, $lastUsage->price, $fractionPrecision);
        $totalAmount = bcadd($loggedTotal, $currentUsage, $fractionPrecision);

        $data = array(
            'order_id' => $id,
        );
        $result = $this->api_admin->meteredbilling_get_total_cost($data);

        $this->assertEquals($totalAmount, $result, 'Metered billing usage calculation incorrect');


    }
}