<?php
/**
 * @group Core
 */
class Box_LicenseTest extends PHPUnit\Framework\TestCase
{
    public function setup()
    {
        global $di;
        $this->di = $di;
    }

    public function testLicense()
    {
        $license = $this->di['license'];
        $details = $license->getDetails();
        $this->assertTrue(is_array($details));
    }
}
