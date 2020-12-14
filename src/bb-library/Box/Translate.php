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

use Gettext\Loader\PoLoader;
use Gettext\Generator\MoGenerator;
use Gettext\Translation;

class Box_Translate implements \Box\InjectionAwareInterface
{
    /**
     * @var \Box_Di
     */
    protected $di = NULL;

    protected $domain = 'messages';

    protected $locale = 'en_US';

    /**
     * @return string
     */
    public function getLocale()
    {
        return $this->locale;
    }

    /**
     * @param string $locale
     * @return Box_Translate
     */
    public function setLocale($locale)
    {
        $this->locale = $locale;
        return $this;
    }

    /**
     * @param Box_Di $di
     */
    public function setDi($di)
    {
        $this->di = $di;
    }

    /**
     * @return Box_Di
     */
    public function getDi()
    {
        return $this->di;
    }

    public function setup()
    {
        $locale = $this->getLocale();
        $codeset = "UTF-8";
        
        if (!function_exists('__')) {
            function __($msgid, array $values = NULL)
            {
                if (empty($msgid)) return null;

                $loader = new PoLoader();
                $translations = $loader->loadFile('./bb-locale/' . "en_US" . '/LC_MESSAGES/messages.po');
                $translation = $translations->find(null, $msgid);
                $str = empty($translation) ? $msgid : $translation->getTranslation();

                return empty($values) ? $str : strtr($str, $values); 
            }
        }
    }

    /**
     * @return string
     */
    public function getDomain()
    {
        return $this->domain;
    }

    /**
     * @param $domain
     * @return Box_Translate
     */
    public function setDomain($domain)
    {
        $this->domain = $domain;
        return $this;
    }

    public function __($msgid, array $values = NULL)
    {
        return __($msgid, $values);
    }
}