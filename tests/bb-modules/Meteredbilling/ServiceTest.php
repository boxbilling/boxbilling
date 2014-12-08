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

    public function testlogUsage()
    {
        $planId = 1;
        $clientId = 3;
        $orderId = 2;
        $productId = 5;

        $model = new \Model_MeteredUsage();
        $model->loadBean(new \RedBeanPHP\OODBBean());

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('dispense')
            ->willReturn($model);

        $dbMock->expects($this->atLeastOnce())
            ->method('store');

        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('calculateUsageCost'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('calculateUsageCost')
            ->willReturn(0);


        $di = new \Box_Di();
        $di['db'] = $dbMock;

        $serviceMock->setDi($di);
        $result = $serviceMock->logUsage($planId, $clientId, $orderId, $productId);
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

    public function testcalculateUsageCost_FIrstUsageLog()
    {
        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('findLastUnbilledUsage'))
            ->getMock();

        $serviceMock->expects($this->atLeastOnce())
            ->method('findLastUnbilledUsage');

        $model = new \Model_MeteredUsage();
        $model->loadBean(new \RedBeanPHP\OODBBean());

        $result = $serviceMock->calculateUsageCost(date('c'), $model);
        $this->assertEquals($result, 0);
    }


    public function testcalculateUsageCost()
    {
        $serviceMock = $this->getMockBuilder('Box\Mod\Meteredbilling\Service')
            ->setMethods(array('findLastUnbilledUsage'))
            ->getMock();

        $lastUsageModel = new \Model_MeteredUsage();
        $lastUsageModel->loadBean(new \RedBeanPHP\OODBBean());
        $intervalInHours = 24;
        $lastUsageModel->created_at = date('c', strtotime(sprintf('-%d hours', $intervalInHours)));

        $serviceMock->expects($this->atLeastOnce())
            ->method('findLastUnbilledUsage')
            ->willReturn($lastUsageModel);

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

        $serviceMock->setDi($di);

        $client_id = 1;
        $order_id = 2;

        $result = $serviceMock->calculateUsageCost(date('c'), $client_id, $order_id);
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
}
 