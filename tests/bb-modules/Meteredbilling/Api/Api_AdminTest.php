<?php
namespace Box\Mod\Api\Meteredbilling;

class AdminTest extends \PHPUnit_Framework_TestCase
{

    /**
     * @var \Box\Mod\Meteredbilling\Api\Admin
     */
    protected $api = null;

    public function setup()
    {
        $this->api = new \Box\Mod\Meteredbilling\Api\Admin();
    }

    public function testgetDi()
    {
        $di = new \Box_Di();
        $this->api->setDi($di);
        $getDi = $this->api->getDi();
        $this->assertEquals($di, $getDi);
    }

    public function testget_total_cost()
    {
        $validatorMock = $this->getMockBuilder('\Box_Validate')->disableOriginalConstructor()->getMock();
        $validatorMock->expects($this->atLeastOnce())
            ->method('checkRequiredParamsForArray');

        $model = new \Model_ClientOrder();
        $model->loadBean(new \RedBeanPHP\OODBBean());


        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getExistingModelById')
            ->with('ClientOrder')
            ->willReturn($model);

        $di = new \Box_Di();
        $di['db'] = $dbMock;
        $di['validator'] = $validatorMock;
        $this->api->setDi($di);

        $serviceMock = $this->getMockBuilder('\Box\Mod\Meteredbilling\Service')->getMock();
        $serviceMock->expects($this->atLeastOnce())
            ->method('getOrderUsageTotalCost')
            ->willReturn(0.000001);
        $this->api->setService($serviceMock);

        $data = array('order_id' => 1);
        $result = $this->api->get_total_cost($data);
        $this->assertGreaterThan(0.00000000, $result);
    }
}
 