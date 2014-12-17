<?php


namespace Box\Mod\Product\Api;


class ClientTest extends \PHPUnit_Framework_TestCase {

    /**
     * @var \Box\Mod\Product\Api\Client
     */
    protected $api = null;

    public function setup()
    {
        $this->api= new \Box\Mod\Product\Api\Client();
    }


    public function testgetDi()
    {
        $di = new \Box_Di();
        $this->api->setDi($di);
        $getDi = $this->api->getDi();
        $this->assertEquals($di, $getDi);
    }

    public function testget_changeable_products()
    {
        $data = array('id' => 1);
        $model = new \Model_Product();
        $model->loadBean(new \RedBeanPHP\OODBBean());

        $dbMock = $this->getMockBuilder('\Box_Database')->getMock();
        $dbMock->expects($this->atLeastOnce())
            ->method('load')
            ->will($this->returnValue($model));

        $serviceMock = $this->getMockBuilder('\Box\Mod\Product\Service')->getMock();
        $serviceMock->expects($this->atLeastOnce())
            ->method('getChangeableProductPairsForClient')
            ->will($this->returnValue(array()));

        $di = new \Box_Di();
        $di['db'] = $dbMock;
        $this->api->setDi($di);
        $this->api->setService($serviceMock);

        $result = $this->api->get_changeable_products($data);
        $this->assertInternalType('array', $result);
    }

}
 