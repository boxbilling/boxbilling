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


class Box_Crypt implements \Box\InjectionAwareInterface
{
    protected $di = NULL;
    protected $crypter = NULL;

    public function setDi($di)
    {
        $this->di = $di;

        $salt = $di['config']['salt'];
        $this->crypter = new NoProtocol\Encryption\MySQL\AES\Crypter($salt);
    }

    public function getDi()
    {
        return $this->di;
    }

    public function encrypt($text)
    {
        $enc = $this->crypter->encrypt($text);
        return base64_encode($enc);
    }

    public function decrypt($text)
    {
        if (is_null($text)){
            return false;
        }
        $dec = base64_decode($text);
        return $this->crypter->decrypt($dec);
    }
}