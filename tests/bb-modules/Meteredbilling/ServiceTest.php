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
            ->setMethods(array('calculateProductUsage'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('calculateProductUsage')
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

    public function testcalculateProductUsage()
    {
        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('findLastLoggedProductUsage', 'quantity'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('findLastLoggedProductUsage');
        $serviceMock->expects($this->atLeastOnce())
            ->method('quantity')
            ->willReturn(0);

        $model = new \Model_MeteredUsage();
        $model->loadBean(new \RedBeanPHP\OODBBean());

        $result = $serviceMock->calculateProductUsage($model);
        $this->assertEquals($result, 0);
    }

    public function testquantity()
    {
        $lastUsageModel = new \Model_MeteredUsage();
        $lastUsageModel->loadBean(new \RedBeanPHP\OODBBean());
        $intervalInHours = 24;
        $lastUsageModel->created_at = date('c', strtotime(sprintf('-%d hours', $intervalInHours)));

        $currentTime =  date('c');
        $result = $this->service->quantity($lastUsageModel, $currentTime);
        $this->assertGreaterThan(0.00000000, $result);
        $this->assertEquals(strtotime($currentTime) - strtotime($lastUsageModel->created_at), $result);

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
 