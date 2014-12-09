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

        $di = new \Box_Di();
        $di['db'] = $dbMock;
        $di['tools'] = $toolsMock;

        $this->service->setDi($di);

        $clientOrder = new \Model_ClientOrder();
        $clientOrder->loadBean(new \RedBeanPHP\OODBBean());

        $result = $this->service->create($clientOrder);
        $this->assertInstanceOf('\Model_MeteredUsage', $result);

    }

    public function testsave()
    {
        $model = new \Model_MeteredUsage();
        $model->loadBean(new \RedBeanPHP\OODBBean());

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('store');

        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('calculateProductUsageCost'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('calculateProductUsageCost')
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

    public function testcalculateProductUsageCost()
    {
        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('findLastLoggedProductUsage', 'cost'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('findLastLoggedProductUsage');
        $serviceMock->expects($this->atLeastOnce())
            ->method('cost')
            ->willReturn(0);

        $model = new \Model_MeteredUsage();
        $model->loadBean(new \RedBeanPHP\OODBBean());

        $result = $serviceMock->calculateProductUsageCost($model);
        $this->assertEquals($result, 0);
    }

    public function testcalculateCurrentUsageCost()
    {
        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('findLastUnbilledUsage', 'cost'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('findLastUnbilledUsage');
        $serviceMock->expects($this->atLeastOnce())
            ->method('cost')
            ->willReturn(0);

        $client_id = 1;
        $order_id = 2;

        $result = $serviceMock->calculateCurrentUsageCost(date('c'), $client_id, $order_id);
        $this->assertEquals($result, 0);
    }


    public function testcost()
    {
        $lastUsageModel = new \Model_MeteredUsage();
        $lastUsageModel->loadBean(new \RedBeanPHP\OODBBean());
        $intervalInHours = 24;
        $lastUsageModel->created_at = date('c', strtotime(sprintf('-%d hours', $intervalInHours)));

        $di = new \Box_Di();

        $meteredPrice = 10;
        $productServiceMock = $this->getMockBuilder('\Box\Mod\Product\Service')->getMock();
        $productServiceMock->expects($this->atLeastOnce())
            ->method('getMeteredPrice')
            ->willReturn($meteredPrice);

        $di['mod_service'] = $di->protect(function ($serviceName) use ($productServiceMock){
            if ($serviceName == 'Product'){
                return $productServiceMock;
            }

            return null;
        });

        $this->service->setDi($di);

        $result = $this->service->cost($lastUsageModel, date('c'));
        $this->assertGreaterThan(0.00000000, $result);
        $this->assertEquals($intervalInHours * $meteredPrice, $result);

    }

    public function testgetUnbilledUsage()
    {
        $client_id = 1;

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('find')
            ->with('MeteredBilling')
            ->willReturn(array());

        $di = new \Box_Di();
        $di['db'] = $dbMock;

        $this->service->setDi($di);
        $result = $this->service->getUnbilledUsage($client_id);
        $this->assertInternalType('array', $result);
    }

    public function testgetOrderUsageTotalCost()
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
        $this->assertEquals($usedTotalCost + $usedCurrentCost, $result);
    }
}
 