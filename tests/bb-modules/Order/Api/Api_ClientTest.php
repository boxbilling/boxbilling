<?php

/**
 * Created by PhpStorm.
 * User: giedrius
 * Date: 8/5/14
 * Time: 4:52 PM
 */
class ClientTest extends PHPUnit_Framework_TestCase
{
    /**
     * @var \Box\Mod\Order\Api\Client
     */
    protected $api = null;

    public function setup()
    {
        $this->api = new \Box\Mod\Order\Api\Client();
    }

    public function testgetDi()
    {
        $di = new \Box_Di();
        $this->api->setDi($di);
        $getDi = $this->api->getDi();
        $this->assertEquals($di, $getDi);
    }

    public function testGet_list()
    {
        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')
            ->setMethods(array('getSearchQuery', 'toApiArray'))->getMock();
        $serviceMock->expects($this->atLeastOnce())->method('getSearchQuery')
            ->will($this->returnValue(array('query', array())));
        $serviceMock->expects($this->atLeastOnce())->method('toApiArray')
            ->will($this->returnValue(array()));

        $resultSet = array(
            'list' => array(
                0 => array('id' => 1),
            ),
        );
        $paginatorMock = $this->getMockBuilder('\Box_Pagination')->disableOriginalConstructor()->getMock();
        $paginatorMock->expects($this->atLeastOnce())
            ->method('getAdvancedResultSet')
            ->will($this->returnValue($resultSet));

        $clientOrderMock = new \Model_ClientOrder();
        $clientOrderMock->loadBean(new \RedBeanPHP\OODBBean());

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getExistingModelById')
            ->with('ClientOrder')
            ->will($this->returnValue($clientOrderMock));

        $di          = new \Box_Di();
        $di['pager'] = $paginatorMock;
        $di['db'] = $dbMock;
        $this->api->setDi($di);

        $client = new Model_Client();
        $client->loadBean(new \RedBeanPHP\OODBBean());
        $client->id = rand(1, 100);

        $this->api->setIdentity($client);
        $this->api->setService($serviceMock);

        $result = $this->api->get_list(array());

        $this->assertInternalType('array', $result);
    }

    public function testGet_listExpiring()
    {
        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')
            ->setMethods(array('getSoonExpiringActiveOrdersQuery'))->getMock();
        $serviceMock->expects($this->atLeastOnce())->method('getSoonExpiringActiveOrdersQuery')
            ->will($this->returnValue(array('query', array())));

        $paginatorMock = $this->getMockBuilder('\Box_Pagination')->disableOriginalConstructor()->getMock();
        $paginatorMock->expects($this->atLeastOnce())
            ->method('getAdvancedResultSet')
            ->will($this->returnValue(array('list' => array())));

        $di          = new \Box_Di();
        $di['pager'] = $paginatorMock;
        $this->api->setDi($di);

        $client = new Model_Client();
        $client->loadBean(new \RedBeanPHP\OODBBean());
        $client->id = rand(1, 100);

        $this->api->setIdentity($client);
        $this->api->setService($serviceMock);

        $data   = array(
            'expiring' => true
        );
        $result = $this->api->get_list($data);

        $this->assertInternalType('array', $result);
    }

    public function testGet()
    {
        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')
            ->setMethods(array('toApiArray'))->getMock();
        $serviceMock->expects($this->atLeastOnce())->method('toApiArray')
            ->will($this->returnValue(array()));

        $apiMock->setService($serviceMock);

        $data   = array(
            'id' => rand(1, 100)
        );
        $result = $apiMock->get($data);

        $this->assertInternalType('array', $result);
    }

    public function testAddons()
    {
        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')
            ->setMethods(array('getOrderAddonsList', 'toApiArray'))->getMock();
        $serviceMock->expects($this->atLeastOnce())->method('getOrderAddonsList')
            ->will($this->returnValue(array(new Model_ClientOrder())));
        $serviceMock->expects($this->atLeastOnce())->method('toApiArray')
            ->will($this->returnValue(array()));

        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $apiMock->setService($serviceMock);

        $data   = array(
            'status' => Model_ClientOrder::STATUS_ACTIVE
        );
        $result = $apiMock->addons($data);

        $this->assertInternalType('array', $result);
        $this->assertInternalType('array', $result[0]);
    }

    public function testService()
    {
        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')
            ->setMethods(array('getOrderServiceData'))->getMock();
        $serviceMock->expects($this->atLeastOnce())->method('getOrderServiceData')
            ->will($this->returnValue(array()));

        $client = new Model_Client();
        $client->loadBean(new \RedBeanPHP\OODBBean());

        $apiMock->setService($serviceMock);
        $apiMock->setIdentity($client);

        $data   = array(
            'id' => rand(1, 100)
        );
        $result = $apiMock->service($data);

        $this->assertInternalType('array', $result);
    }

    public function testUpgradables()
    {
        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $productServiceMock = $this->getMockBuilder('\Box\Mod\Product\Service')->setMethods(array('getUpgradablePairs'))->getMock();
        $productServiceMock->expects($this->atLeastOnce())
            ->method("getUpgradablePairs")
            ->will($this->returnValue(array()));

        $product = new Model_Product();
        $product->loadBean(new RedBeanPHP\OODBBean());

        $dbMock = $this->getMockBuilder('\Box_Database')->disableOriginalConstructor()->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getExistingModelById')
            ->will($this->returnValue($product));

        $di                = new \Box_Di();
        $di['db']          = $dbMock;
        $di['mod_service'] = $di->protect(function () use ($productServiceMock) {
            return $productServiceMock;
        });
        $apiMock->setDi($di);
        $data = array();

        $result = $apiMock->upgradables($data);
        $this->assertInternalType('array', $result);
    }

    public function testDelete()
    {
        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());
        $order->status = Model_ClientOrder::STATUS_PENDING_SETUP;

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')
            ->setMethods(array('deleteFromOrder'))->getMock();
        $serviceMock->expects($this->atLeastOnce())->method('deleteFromOrder')
            ->will($this->returnValue(true));

        $apiMock->setService($serviceMock);

        $data   = array(
            'id' => rand(1, 100)
        );
        $result = $apiMock->delete($data);

        $this->assertTrue($result);
    }

    /**
     * @expectedException \Box_Exception
     */
    public function testDeleteNotPendingException()
    {
        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')
            ->setMethods(array('deleteFromOrder'))->getMock();
        $serviceMock->expects($this->never())->method('deleteFromOrder')
            ->will($this->returnValue(true));

        $apiMock->setService($serviceMock);

        $data   = array(
            'id' => rand(1, 100)
        );
        $result = $apiMock->delete($data);

        $this->assertTrue($result);
    }

    public function testGetOrder()
    {
        $validatorMock = $this->getMockBuilder('\Box_Validate')->disableOriginalConstructor()->getMock();
        $validatorMock->expects($this->atLeastOnce())
            ->method('checkRequiredParamsForArray')
            ->will($this->returnValue(null));

        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());

        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')
            ->setMethods(array('findForClientById', 'toApiArray'))->getMock();
        $serviceMock->expects($this->atLeastOnce())->method('findForClientById')
            ->will($this->returnValue($order));
        $serviceMock->expects($this->atLeastOnce())->method('toApiArray')
            ->will($this->returnValue(array()));

        $order = new \Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());

        $client = new Model_Client();
        $client->loadBean(new \RedBeanPHP\OODBBean());

        $di              = new Box_Di();
        $di['validator'] = $validatorMock;
        $this->api->setDi($di);

        $this->api->setService($serviceMock);
        $this->api->setIdentity($client);

        $data = array(
            'id' => rand(1, 100)
        );
        $this->api->get($data);
    }

    /**
     * @expectedException \Box_Exception
     */
    public function testGetOrderNotFoundException()
    {
        $validatorMock = $this->getMockBuilder('\Box_Validate')->disableOriginalConstructor()->getMock();
        $validatorMock->expects($this->atLeastOnce())
            ->method('checkRequiredParamsForArray')
            ->will($this->returnValue(null));

        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')
            ->setMethods(array('findForClientById', 'toApiArray'))->getMock();
        $serviceMock->expects($this->atLeastOnce())->method('findForClientById')
            ->will($this->returnValue(null));
        $serviceMock->expects($this->never())->method('toApiArray')
            ->will($this->returnValue(array()));

        $order = new \Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());

        $client = new Model_Client();
        $client->loadBean(new \RedBeanPHP\OODBBean());

        $di              = new Box_Di();
        $di['validator'] = $validatorMock;
        $this->api->setDi($di);

        $this->api->setService($serviceMock);
        $this->api->setIdentity($client);

        $data = array(
            'id' => rand(1, 100)
        );
        $this->api->get($data);
    }

    public function testis_metered()
    {
        $data = array(
            'id' => 1,
        );

        $model = new \Model_ClientOrder();
        $model->loadBean(new \RedBeanPHP\OODBBean());


        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')->getMock();
        $serviceMock->expects($this->atLeastOnce())
            ->method('haveMeteredBilling')
            ->with($model)
            ->will($this->returnValue(true));

        $serviceMock->expects($this->atLeastOnce())
            ->method('findForClientById')
            ->willReturn($model);

        $this->api->setService($serviceMock);

        $validatorMock = $this->getMockBuilder('\Box_Validate')->disableOriginalConstructor()->getMock();
        $validatorMock->expects($this->atLeastOnce())
            ->method('checkRequiredParamsForArray');

        $di = new \Box_Di();
        $di['validator'] = $validatorMock;

        $this->api->setDi($di);

        $identity = new \Model_Client();
        $identity->loadBean(new \RedBeanPHP\OODBBean());
        $this->api->setIdentity($identity);

        $result = $this->api->is_metered($data);
        $this->assertTrue($result);
    }

    public function testSuspend()
    {
        $client_id = 1;
        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());
        $order->client_id = $client_id;

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')
            ->setMethods(array('suspendFromOrder'))->getMock();
        $serviceMock->expects($this->atLeastOnce())->method('suspendFromOrder')
            ->will($this->returnValue(true));

        $apiMock->setService($serviceMock);

        $identity = new \Model_Client();
        $identity->loadBean(new \RedBeanPHP\OODBBean());
        $identity->id = $client_id;
        $apiMock->setIdentity($identity);

        $data   = array('id' => 1);
        $result = $apiMock->suspend($data);

        $this->assertTrue($result);
    }

    public function testSuspend_IdentityIdsMismatch()
    {
        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());
        $order->client_id = 2;

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $identity = new \Model_Client();
        $identity->loadBean(new \RedBeanPHP\OODBBean());
        $identity->id = 1;
        $apiMock->setIdentity($identity);

        $data   = array('id' => 1);
        $this->setExpectedException('\Box_Exception', 'Order was not found');
        $apiMock->suspend($data);
    }

    public function testUnsuspend()
    {
        $client_id = 1;

        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());
        $order->status = Model_ClientOrder::STATUS_SUSPENDED;
        $order->client_id = $client_id;

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $orderStatusModel = new \Model_ClientOrderStatus();
        $orderStatusModel->loadBean(new \RedBeanPHP\OODBBean());
        $orderStatusModel->notes = 'Order suspended for Client suspended order';

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('findOne')
            ->with('ClientOrderStatus')
            ->willReturn($orderStatusModel);

        $di = new \Box_Di();
        $di['db'] = $dbMock;
        $apiMock->setDi($di);

        $identity = new \Model_Client();
        $identity->loadBean(new \RedBeanPHP\OODBBean());
        $identity->id = $client_id;
        $apiMock->setIdentity($identity);

        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')
            ->setMethods(array('unsuspendFromOrder'))->getMock();
        $serviceMock->expects($this->atLeastOnce())->method('unsuspendFromOrder')
            ->will($this->returnValue(true));

        $apiMock->setService($serviceMock);

        $data   = array('id' => 1);
        $result = $apiMock->unsuspend($data);

        $this->assertTrue($result);
    }

    public function testUnsuspend_AdministratorSuspended()
    {
        $client_id = 1;

        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());
        $order->status = Model_ClientOrder::STATUS_SUSPENDED;
        $order->client_id = $client_id;

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $orderStatusModel = new \Model_ClientOrderStatus();
        $orderStatusModel->loadBean(new \RedBeanPHP\OODBBean());
        $orderStatusModel->notes = 'Order suspended for';

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('findOne')
            ->with('ClientOrderStatus')
            ->willReturn($orderStatusModel);

        $di = new \Box_Di();
        $di['db'] = $dbMock;
        $apiMock->setDi($di);

        $identity = new \Model_Client();
        $identity->loadBean(new \RedBeanPHP\OODBBean());
        $identity->id = $client_id;
        $apiMock->setIdentity($identity);

        $data   = array('id' => 1);
        $this->setExpectedException('\Box_Exception', 'Order was suspended by administrator');
        $apiMock->unsuspend($data);
    }

    public function testUnsuspendIdentityException()
    {
        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());
        $order->status = Model_ClientOrder::STATUS_SUSPENDED;
        $order->client_id = 2;

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $identity = new \Model_Client();
        $identity->loadBean(new \RedBeanPHP\OODBBean());
        $identity->id = 1;
        $apiMock->setIdentity($identity);


        $data   = array('id' => 1);
        $this->setExpectedException('\Box_Exception', 'Order was not found');
        $apiMock->unsuspend($data);
    }

    public function testUnsuspendNotSuspendedException()
    {
        $order = new Model_ClientOrder();
        $order->loadBean(new \RedBeanPHP\OODBBean());
        $order->status = Model_ClientOrder::STATUS_ACTIVE;

        $apiMock = $this->getMockBuilder('\\Box\Mod\Order\Api\Client')->setMethods(array('_getOrder'))->disableOriginalConstructor()->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($order));

        $data   = array('id' => 1);
        $this->setExpectedException('\Box_Exception', 'Only suspended orders can be unsuspended');
        $apiMock->unsuspend($data);
    }

    public function testchange_order_product()
    {
        $data = array(
            'id' => 1,
            'product_id' => 2,
        );

        $modelOrder = new \Model_ClientOrder();
        $modelOrder->loadBean(new \RedBeanPHP\OODBBean());

        $modelProduct = new \Model_Product();
        $modelProduct->loadBean(new \RedBeanPHP\OODBBean());

        $validatorMock = $this->getMockBuilder('\Box_Validate')->disableOriginalConstructor()->getMock();
        $validatorMock->expects($this->atLeastOnce())
            ->method('checkRequiredParamsForArray')
            ->will($this->returnValue(null));

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getExistingModelById')
            ->with('Product')
            ->willReturn($modelProduct);

        $di = new Box_Di();
        $di['db'] = $dbMock;
        $di['validator'] = $validatorMock;

        $apiMock = $this->getMockBuilder('\Box\Mod\Order\Api\Client')
            ->setMethods(array('_getOrder'))
            ->disableOriginalConstructor()
            ->getMock();
        $apiMock->expects($this->atLeastOnce())
            ->method('_getOrder')
            ->will($this->returnValue($modelOrder));

        $apiMock->setDi($di);

        $serviceMock = $this->getMockBuilder('\Box\Mod\Order\Service')->getMock();
        $serviceMock->expects($this->atLeastOnce())
            ->method('changeOrderProduct')
            ->will($this->returnValue(true));
        $apiMock->setService($serviceMock);

        $identity = new \Model_Client();
        $apiMock->setIdentity($identity);

        $result = $apiMock->change_order_product($data);
        $this->assertTrue($result);
    }
}
 