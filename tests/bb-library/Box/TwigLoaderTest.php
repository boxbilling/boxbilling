<?php
/**
 * @group Core
 */


class Box_TwigLoaderTest extends PHPUnit\Framework\TestCase
{
    protected function setUp(): void
    {
        global $di;
        $this->di = $di;
        $this->twig = $di['twig'];

        $this->loader = new Box_TwigLoader(array(
            "mods" => BB_PATH_MODS,
            "theme" => BB_PATH_THEMES.DIRECTORY_SEPARATOR."huraga",
            "type" => "client"
        ));
    }

    public function testTemplates()
    {
        $test =  $this->loader->getSource("mod_example_index.phtml");
        $test2 =  $this->loader->getSource("404.phtml");

        $this->assertIsString($test);
        $this->assertIsString($test2);
    }

    /**
     * @expectedException Twig_Error_Loader
     */
    public function testException()
    {
        $test =  $this->loader->getSource("mod_non_existing_settings.phtml");
        $test =  $this->loader->getSource("some_random_name.phtml");
    }

    public function testTwigFilterAlink()
    {
        $template = $this->twig->createTemplate('{{ link | alink }}');
        $result = $template->render();
        $this->assertContains('bb-admin', $result);
    }

    public function testTwigFilterLink()
    {
        $template = $this->twig->createTemplate('{{ "/some-url" | link }}');
        $result = $template->render();
        $this->assertContains('/some-url', $result);
    }

    public function testTwigFilterGravatar()
    {
        $template = $this->twig->createTemplate('{{ "example@email.com" | gravatar }}');
        $result = $template->render();
        $this->assertContains('gravatar.com', $result);
    }

    public function testTwigFilterMarkdown()
    {
        $template = $this->twig->createTemplate('{{ "**bolded text**" | markdown }}');
        $result = $template->render();
        $this->assertContains('<strong>', $result);
        $this->assertContains('</strong>', $result);
    }

    public function testTwigFilterTruncate()
    {
        $template = $this->twig->createTemplate('{{ "**bolded text**" | truncate(2) }}');
        $result = $template->render();
        $this->assertTrue((strlen($result) == 5), $result);
        $this->assertStringEndsWith('...', $result);
    }

    public function testTwigFilterTimeago()
    {
        $now = date('c');
        $template = $this->twig->createTemplate("{{ '$now' | timeago }}");
        $result = $template->render();
        $this->assertContains('second', $result);
    }

    public function testTwigFilterDaysleft()
    {
        $now = date('c');
        $template = $this->twig->createTemplate("{{ '$now' | daysleft }}");
        $result = $template->render();
        $this->assertEquals('0', $result);
    }

    public function testTwigFilterSize()
    {
        $template = $this->twig->createTemplate("{{ 2048 | size }}");
        $result = $template->render();
        $this->assertEquals('2 KB', $result);
    }

    public function testTwigFilterIpcountryname()
    {
        $template = $this->twig->createTemplate("{{ '8.8.8.8' | ipcountryname }}");
        $result = $template->render();
        $this->assertEquals('United States', $result);
    }

    public function testTwigFilterNumber()
    {
        $template = $this->twig->createTemplate("{{ 150.99999 | number }}");
        $result = $template->render();
        $this->assertEquals('151.00', $result);
    }

    public function testTwigFilterPeriodTitle()
    {
        $template = $this->twig->createTemplate("{{ '1M' | period_title }}");
        $result = $template->render();
        $this->assertEquals('Every month', $result);
    }

    public function testTwigFilterAutolink()
    {
        $template = $this->twig->createTemplate("{{ 'www.google.com and some other' | autolink }}");
        $result = $template->render();
        $this->assertContains('http', $result);
    }

    public function testTwigFilterBbmd()
    {
        $template = $this->twig->createTemplate("{{ 'www.google.com and some other' | bbmd }}");
        $result = $template->render();
        $this->assertContains('<p>', $result);
        $this->assertContains('</p>', $result);
    }

    public function testTwigFilterBbDate()
    {
        $template = $this->twig->createTemplate("{{ '2020-02-02 14:20:02' | bb_date('%m') }}");
        $result = $template->render();
        $this->assertEquals('02', $result);
    }

    public function testTwigFilterBbDateTime()
    {
        $template = $this->twig->createTemplate("{{ '2020-02-02 14:20:02' | bb_datetime('%H') }}");
        $result = $template->render();
        $this->assertEquals('14', $result);
    }

    public function testTwigFilterImgTag()
    {
        $template = $this->twig->createTemplate("{{ 'http://1.gravatar.com/avatar/767fc9c115a1b989744c755db47feb60' | img_tag }}");
        $result = $template->render();
        $this->assertContains('<img src', $result);
        $this->assertContains('alt=', $result);
    }

    public function testTwigFilterScriptTag()
    {
        $template = $this->twig->createTemplate("{{ 'https://code.jquery.com/jquery-1.12.4.min.js' | script_tag }}");
        $result = $template->render();
        $this->assertContains('<script type="text/javascript"', $result);
    }

    public function testTwigFilterStylesheetTag()
    {
        $template = $this->twig->createTemplate("{{ 'https://getbootstrap.com/docs/3.4/dist/css/bootstrap.min.css' | stylesheet_tag }}");
        $result = $template->render();
        $this->assertContains('<link rel="stylesheet" type="text/css"', $result);
    }

    public function testTwigFilterModAssetUrl()
    {
        $template = $this->twig->createTemplate("{{ 'bootstrap.min.css' | mod_asset_url('example') }}");
        $result = $template->render();
        $this->assertContains('bb-modules/Example/assets', $result);
    }

    public function testTwigFilterAssetUrl()
    {
        $template = $this->twig->createTemplate("{{ 'bootstrap.min.css' | asset_url }}");
        $result = $template->render();
        $this->assertContains('/bb-themes/', $result);
    }

    public function testTwigFilterMoney()
    {
        $template = $this->twig->createTemplate("{{ 105 | money }}");
        $result = $template->render();
        $this->assertContains('$', $result);
    }

    public function testTwigFilterMoneyWithoutCurrency()
    {
        $template = $this->twig->createTemplate("{{ 105 | money_without_currency }}");
        $result = $template->render();
        $this->assertEquals('105.00', $result);
    }

    public function testTwigFilterMoneyConvert()
    {
        $template = $this->twig->createTemplate("{{ 105 | money_convert('USD') }}");
        $result = $template->render();
        $this->assertEquals('$105.00', $result);

        //@todo add test with custom currency
        //$template = $this->twig->createTemplate("{{ 105 | money_convert('EUR') }}");
    }

    public function testTwigFilterMoneyConvertWithoutCurrency()
    {
        $template = $this->twig->createTemplate("{{ 105 | money_convert_without_currency('USD') }}");
        $result = $template->render();
        $this->assertEquals('105.00', $result);
    }
}