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
}
 