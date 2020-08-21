<?php
namespace Box\Mod\Api\Meteredbilling;

class ClientTest extends \PHPUnit_Framework_TestCase
{

    /**
     * @var \Box\Mod\Meteredbilling\Api\Client
     */
    protected $api = null;

    public function setup()
    {
        $this->api = new \Box\Mod\Meteredbilling\Api\Client();
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

        $clientId = 1;

        $model = new \Model_ClientOrder();
        $model->loadBean(new \RedBeanPHP\OODBBean());
        $model->client_id = $clientId;

        $identity = new \Model_Client();
        $identity->loadBean(new \RedBeanPHP\OODBBean());
        $identity->id = $clientId;
        $this->api->setIdentity($identity);

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

    public function testget_total_cost_OrderDoesNotBelogToUser()
    {
        $validatorMock = $this->getMockBuilder('\Box_Validate')->disableOriginalConstructor()->getMock();
        $validatorMock->expects($this->atLeastOnce())
            ->method('checkRequiredParamsForArray');

        $clientId = 1;

        $model = new \Model_ClientOrder();
        $model->loadBean(new \RedBeanPHP\OODBBean());
        $model->client_id = $clientId;

        $identity = new \Model_Client();
        $identity->loadBean(new \RedBeanPHP\OODBBean());
        $identity->id = 2;
        $this->api->setIdentity($identity);

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getExistingModelById')
            ->with('ClientOrder')
            ->willReturn($model);

        $di = new \Box_Di();
        $di['db'] = $dbMock;
        $di['validator'] = $validatorMock;
        $this->api->setDi($di);

        $data = array('order_id' => 1);
        $this->setExpectedException('\Box_Exception', 'Order not found', 5547);
        $this->api->get_total_cost($data);
    }

    public function testget_order_usage_list()
    {
        $validatorMock = $this->getMockBuilder('\Box_Validate')->disableOriginalConstructor()->getMock();
        $validatorMock->expects($this->atLeastOnce())
            ->method('checkRequiredParamsForArray');

        $clientId = 1;

        $model = new \Model_ClientOrder();
        $model->loadBean(new \RedBeanPHP\OODBBean());
        $model->client_id = $clientId;

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getExistingModelById')
            ->with('ClientOrder')
            ->willReturn($model);

        $di = new \Box_Di();
        $di['db'] = $dbMock;
        $di['validator'] = $validatorMock;
        $this->api->setDi($di);

        $identity = new \Model_Client();
        $identity->loadBean(new \RedBeanPHP\OODBBean());
        $identity->id = $clientId;
        $this->api->setIdentity($identity);

        $serviceMock = $this->getMockBuilder('\Box\Mod\Meteredbilling\Service')->getMock();
        $serviceMock->expects($this->atLeastOnce())
            ->method('getOrderUsageList')
            ->willReturn(array());
        $this->api->setService($serviceMock);

        $data = array('order_id' => 1);
        $result = $this->api->get_order_usage_list($data);
        $this->assertInternalType('array', $result);
    }

    public function testget_order_usage_list_Exception()
    {
        $validatorMock = $this->getMockBuilder('\Box_Validate')->disableOriginalConstructor()->getMock();
        $validatorMock->expects($this->atLeastOnce())
            ->method('checkRequiredParamsForArray');

        $clientId = 1;

        $model = new \Model_ClientOrder();
        $model->loadBean(new \RedBeanPHP\OODBBean());
        $model->client_id = 2;

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getExistingModelById')
            ->with('ClientOrder')
            ->willReturn($model);

        $di = new \Box_Di();
        $di['db'] = $dbMock;
        $di['validator'] = $validatorMock;
        $this->api->setDi($di);

        $identity = new \Model_Client();
        $identity->loadBean(new \RedBeanPHP\OODBBean());
        $identity->id = $clientId;
        $this->api->setIdentity($identity);

        $data = array('order_id' => 1);
        $this->setExpectedException('\Box_Exception', 'Order not found', 5548);
        $this->api->get_order_usage_list($data);
    }
}
 