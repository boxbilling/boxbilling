<?php
/**
 * BoxBilling
 *
 * @copyright BoxBilling, Inc (http://www.boxbilling.com)
 * @license   Apache-2.0
 *
 * Copyright BoxBilling, Inc
 * This source file is subject to the Apache-2.0 License that is bundled
 * with this source code in the file LICENSE
 */

/**
 * Products management
 */

namespace Box\Mod\Product\Api;

class Client extends \Api_Abstract
{


    /**
     * @param $data - id : product id
     * @return mixed
     * @throws \Box_Exception
     */
    public function get_changeable_products($data)
    {
        if(!isset($data['id'])) {
            throw new \Box_Exception('Product id not passed');
        }

        $model = $this->di['db']->load('Product', $data['id']);
        if(!$model instanceof \Model_Product) {
            throw new \Box_Exception('Product not found');
        }


        return $this->getService()->getChangeableProductPairsForClient($model);
    }
}