<?php

namespace Box\Mod\Meteredbilling;

class ServiceTest extends \PHPUnit_Framework_TestCase
{
    /**
     * @var \Box\Mod\Meteredbilling\Service
     */
    protected $service = null;

    public function setup()
    {
        $this->service = new Service();
    }

    public function testgetDi()
    {
        $di = new \Box_Di();
        $this->service->setDi($di);
        $getDi = $this->service->getDi();
        $this->assertEquals($di, $getDi);
    }

    public function testcreate()
    {
        $model = new \Model_MeteredUsage();
        $model->loadBean(new \RedBeanPHP\OODBBean());

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('dispense')
            ->willReturn($model);

        $productModel = new \Model_Product();
        $productModel->loadBean(new \RedBeanPHP\OODBBean());
        $dbMock->expects($this->atLeastOnce())
            ->method('load')
            ->willReturn($productModel);

        $toolsMock = $this->getMockBuilder('\Box_Tools')->getMock();
        $toolsMock->expects($this->atLeastOnce())
            ->method('decodeJ')
            ->willReturn(array());

        $meteredPrice = 10;
        $productServiceMock = $this->getMockBuilder('\Box\Mod\Product\Service')->getMock();
        $productServiceMock->expects($this->atLeastOnce())
            ->method('getMeteredPrice')
            ->willReturn($meteredPrice);


        $di = new \Box_Di();
        $di['db'] = $dbMock;
        $di['tools'] = $toolsMock;
        $di['mod_service'] = $di->protect(function ($serviceName) use ($productServiceMock){
            if ($serviceName == 'Product'){
                return $productServiceMock;
            }

            return null;
        });

        $this->service->setDi($di);

        $clientOrder = new \Model_ClientOrder();
        $clientOrder->loadBean(new \RedBeanPHP\OODBBean());

        $result = $this->service->create($clientOrder);
        $this->assertInstanceOf('\Model_MeteredUsage', $result);
        $this->assertEquals(bcdiv($meteredPrice, 3600, 8), $result->price, 'Incorrect unit price in seconds');

    }

    public function testsave()
    {
        $model = new \Model_MeteredUsage();
        $model->loadBean(new \RedBeanPHP\OODBBean());

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('store');

        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('getDuration'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('getDuration')
            ->with($model)
            ->willReturn(0);


        $di = new \Box_Di();
        $di['db'] = $dbMock;

        $serviceMock->setDi($di);
        $result = $serviceMock->save($model);
        $this->assertTrue($result);
    }

    public function testfindLastUnbilledUsage_DidntFindUsage()
    {
        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('findOne')
            ->with('MeteredUsage')
            ->willReturn(null);

        $di = new \Box_Di();
        $di['db'] = $dbMock;

        $this->service->setDi($di);
        $result = $this->service->findLastUnbilledUsage(1, 1);
        $this->assertNull($result);
    }

    public function getDuration()
    {
        $lastUsageModel = new \Model_MeteredUsage();
        $lastUsageModel->loadBean(new \RedBeanPHP\OODBBean());
        $intervalInHours = 24;
        $lastUsageModel->created_at = date('c', strtotime(sprintf('-%d hours', $intervalInHours)));

        $currentTime =  date('c');
        $result = $this->service->getDuration($lastUsageModel, $currentTime);
        $this->assertGreaterThan(0.00000000, $result);
        $this->assertEquals(strtotime($currentTime) - strtotime($lastUsageModel->created_at), $result);
    }

    public function getDuration_stoppedAtisNull()
    {
        $lastUsageModel = new \Model_MeteredUsage();
        $lastUsageModel->loadBean(new \RedBeanPHP\OODBBean());
        $intervalInHours = 24;
        $lastUsageModel->created_at = date('c', strtotime(sprintf('-%d hours', $intervalInHours)));

        $currentTime =  null;
        $result = $this->service->getDuration($lastUsageModel, $currentTime);
        $this->assertEquals(0, $result);
    }

    public function testgetOrderUsageTotalCost()
    {
        $model = new \Model_ClientOrder();
        $model->loadBean(new \RedBeanPHP\OODBBean());
        $model->status = \Model_ClientOrder::STATUS_ACTIVE;

        $usedTotalCost = 0.05;
        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getCell')
            ->willReturn($usedTotalCost);

        $di = new \Box_Di();
        $di['db'] = $dbMock;

        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('calculateCurrentUsageCost'))
            ->getMock();

        $usedCurrentCost  = 0.87;
        $serviceMock->expects($this->atLeastOnce())
            ->method('calculateCurrentUsageCost')
            ->willReturn($usedCurrentCost);

        $serviceMock->setDi($di);
        $result = $serviceMock->getOrderUsageTotalCost($model);
        $this->assertGreaterThan(0.00000000, $result);
        $this->assertEquals(bcadd($usedTotalCost, $usedCurrentCost, 8), $result);
    }

    public function testgetOrderUsageTotalCost_OrderIsNotActive()
    {
        $model = new \Model_ClientOrder();
        $model->loadBean(new \RedBeanPHP\OODBBean());

        $usedTotalCost = 0.05;
        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getCell')
            ->willReturn($usedTotalCost);

        $di = new \Box_Di();
        $di['db'] = $dbMock;

        $usedCurrentCost = 0;

        $this->service->setDi($di);
        $result = $this->service->getOrderUsageTotalCost($model);
        $this->assertGreaterThan(0.00000000, $result);
        $this->assertEquals(bcadd($usedTotalCost, $usedCurrentCost, 8), $result);
    }

    public function testgenerateInvoicesOnFirstDayOfTheMonth_NotFirstDay()
    {
        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('isFirstDayOfTheMonth'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('isFirstDayOfTheMonth')
            ->with()
            ->willReturn(false);

        $result = $serviceMock->generateInvoicesOnFirstDayOfTheMonth();
        $this->assertEquals(-1, $result);
    }

    public function testgenerateInvoicesOnFirstDayOfTheMonth_NoOrdersToBill()
    {
        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('isFirstDayOfTheMonth'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('isFirstDayOfTheMonth')
            ->with()
            ->willReturn(true);

        $invoiceMock = $this->getMockBuilder('\Box\Mod\Invoice\Service')->getMock();

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getAll')
            ->willReturn(array());

        $di = new \Box_Di();
        $di['mod_service'] = $di->protect(function ($serviceName) use($invoiceMock){
            if ('Invoice' == $serviceName) {
                return $invoiceMock;
            }
        });
        $di['db'] = $dbMock;

        $serviceMock->setDi($di);


        $result = $serviceMock->generateInvoicesOnFirstDayOfTheMonth();
        $this->assertEquals(0, $result);
    }

    public function testgenerateInvoicesOnFirstDayOfTheMonth()
    {
        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('isFirstDayOfTheMonth'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('isFirstDayOfTheMonth')
            ->with()
            ->willReturn(true);

        $invoiceMock = $this->getMockBuilder('\Box\Mod\Invoice\Service')->getMock();
        $invoiceMock->expects($this->atLeastOnce())
            ->method('generateForOrderWithMeteredBilling');

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getAll')
            ->willReturn(array(
                array('order_id' => 1)));

        $orderModel = new \Model_ClientOrder();
        $orderModel->loadBean(new \RedBeanPHP\OODBBean());
        $dbMock->expects($this->atLeastOnce())
            ->method('load')
            ->willReturn($orderModel);


        $di = new \Box_Di();
        $di['mod_service'] = $di->protect(function ($serviceName) use($invoiceMock){
            if ('Invoice' == $serviceName) {
                return $invoiceMock;
            }
        });
        $di['db'] = $dbMock;

        $serviceMock->setDi($di);


        $result = $serviceMock->generateInvoicesOnFirstDayOfTheMonth();
        $this->assertEquals(1, $result);
    }

    public function testgenerateInvoicesOnFirstDayOfTheMonth_InvoiceGenerateException()
    {
        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('isFirstDayOfTheMonth'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('isFirstDayOfTheMonth')
            ->with()
            ->willReturn(true);

        $invoiceMock = $this->getMockBuilder('\Box\Mod\Invoice\Service')->getMock();
        $invoiceMock->expects($this->atLeastOnce())
            ->method('generateForOrderWithMeteredBilling')
            ->willThrowException(new \Box_Exception('PHP UNit exception'));

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getAll')
            ->willReturn(array(
                array('order_id' => 1)));

        $orderModel = new \Model_ClientOrder();
        $orderModel->loadBean(new \RedBeanPHP\OODBBean());
        $dbMock->expects($this->atLeastOnce())
            ->method('load')
            ->willReturn($orderModel);


        $di = new \Box_Di();
        $di['mod_service'] = $di->protect(function ($serviceName) use($invoiceMock){
            if ('Invoice' == $serviceName) {
                return $invoiceMock;
            }
        });
        $di['db'] = $dbMock;

        $serviceMock->setDi($di);

        $this->setExpectedException('\Box_Exception');
        $serviceMock->generateInvoicesOnFirstDayOfTheMonth();
    }

    public function testgenerateInvoicesOnFirstDayOfTheMonth_ZeroAmountUsage()
    {
        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('isFirstDayOfTheMonth'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('isFirstDayOfTheMonth')
            ->with()
            ->willReturn(true);

        $invoiceMock = $this->getMockBuilder('\Box\Mod\Invoice\Service')->getMock();
        $invoiceMock->expects($this->atLeastOnce())
            ->method('generateForOrderWithMeteredBilling')
            ->willThrowException(new \Box_Exception('Invoices are not generated for 0 amount orders', null, 1157));

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getAll')
            ->willReturn(array(
                array('order_id' => 1)));

        $orderModel = new \Model_ClientOrder();
        $orderModel->loadBean(new \RedBeanPHP\OODBBean());
        $dbMock->expects($this->atLeastOnce())
            ->method('load')
            ->willReturn($orderModel);


        $di = new \Box_Di();
        $di['mod_service'] = $di->protect(function ($serviceName) use($invoiceMock){
            if ('Invoice' == $serviceName) {
                return $invoiceMock;
            }
        });
        $di['db'] = $dbMock;

        $serviceMock->setDi($di);

        $result =$serviceMock->generateInvoicesOnFirstDayOfTheMonth();
        $this->assertEquals(0, $result);
    }

    public function testsuspendOrdersWithUnpaidInvoices_SqlEmptyResult()
    {
        $config = array('metered_order_suspend' => 10);
        $boxModMock = $this->getMockBuilder('\Box_Mod')->disableOriginalConstructor()->getMock();
        $boxModMock->expects($this->atLeastOnce())
            ->method('getConfig')
            ->willReturn($config);

        $getAllResult = array();
        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('getAll')
            ->willReturn($getAllResult);

        $di = new \Box_Di();
        $di['mod'] = $di->protect(function ($extensionName) use($boxModMock) {
            if ($extensionName == 'meteredbilling'){
                return $boxModMock;
            }
            return null;
        });
        $di['db'] = $dbMock;
        $this->service->setDi($di);

        $result = $this->service->suspendOrdersWithUnpaidInvoices();
        $this->assertEquals(-1, $result);
    }

    public function testsuspendOrdersWithUnpaidInvoices()
    {
        $config = array('metered_order_suspend' => 10);
        $boxModMock = $this->getMockBuilder('\Box_Mod')->disableOriginalConstructor()->getMock();
        $boxModMock->expects($this->atLeastOnce())
            ->method('getConfig')
            ->willReturn($config);

        $getAllResult = array(
            array('id' => 1,));
        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();

        $dbMock->expects($this->atLeastOnce())
            ->method('getAll')
            ->willReturn($getAllResult);

        $orderModel = new \Model_ClientOrder();
        $orderModel->loadBean(new \RedBeanPHP\OODBBean());
        $dbMock->expects($this->atLeastOnce())
            ->method('load')
            ->willReturn($orderModel);

        $orderServiceMock = $this->getMockBuilder('\Box\Mod\Order\Service')->getMock();
        $orderServiceMock->expects($this->atLeastOnce())
            ->method('suspendFromOrder')
            ->with($orderModel);

        $di = new \Box_Di();
        $di['mod'] = $di->protect(function ($extensionName) use($boxModMock) {
            if ($extensionName == 'meteredbilling'){
                return $boxModMock;
            }
            return null;
        });
        $di['db'] = $dbMock;
        $di['mod_service'] = $di->protect(function ($serviceName) use($orderServiceMock){
            if ($serviceName == 'Order'){
                return $orderServiceMock;
            }
            return null;
        });
        $this->service->setDi($di);

        $result = $this->service->suspendOrdersWithUnpaidInvoices();
        $this->assertEquals(1, $result);
    }
}
 