<?php

namespace Box\Mod\Meteredbilling;

class ServiceTest extends \PHPUnit_Framework_TestCase
{
    /**
     * @var \Box\Mod\Order\Service
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


        $di = new \Box_Di();
        $di['db'] = $dbMock;

        $this->service->setDi($di);
        $result = $this->service->logUsage($planId, $clientId, $orderId, $productId);
        $this->assertTrue($result);
    }
}
 