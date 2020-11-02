<?php

namespace Box;

use ScssPhp\ScssPhp\Compiler;

class Scss implements InjectionAwareInterface
{
    /**
     * @var \Box_Ii
     */
    protected $di = null;
    
    /**
     * @param \Box_Ii $di
     */
    public function setDi($di)
    {
        $this->di = $di;
    }

    /**
     * @return \Box_Ii
     */
    public function getDi()
    {
        return $this->di;
    }
    
    public function compile($file = 'style.scss', $forceCompile = false): string
    {
        $theme = $this->di['mod_service']('theme');
        
        $asset_path = '/bb-themes/' . $theme->getCurrentClientAreaThemeCode() . '/assets';
 
        if (!file_exists(BB_PATH_ROOT . $asset_path . '/scss'))
        {
            throw new \Exception(BB_PATH_ROOT . $asset_path . '/scss' .' - Failed to find Scss Dir.');
        }
        
        if (!file_exists(BB_PATH_ROOT . $asset_path . '/scss/' . $file))
        {
            throw new \Exception(BB_PATH_ROOT . $asset_path . '/scss/' . $file . ' - Failed to find Scss File.');
        }
        
        if (!file_exists(BB_PATH_ROOT . $asset_path . '/css'))
        {
            throw new \Exception(BB_PATH_ROOT . $asset_path . '/css' .' - Failed to find Css Dir.');
        }
        
        try{
            // Getting a compiler instance
            $scssphp  = new Compiler();

            $scssphp->setVariables(array(
                'assets-path'           => $asset_path,
                'scss-assets-path'      => $asset_path . '/scss',
                'css-assets-path'       => $asset_path . '/css',
                'vendor-assets-path'    => $asset_path . '/vendor',
                'img-assets-path'       => $asset_path . '/img'
            ));

            if (APPLICATION_ENV == 'production')
            {
                $scssphp->setFormatter('ScssPhp\ScssPhp\Formatter\Crunched');
            }else{
                $scssphp->setFormatter('ScssPhp\ScssPhp\Formatter\Expanded');
            }

            $scssphp->setImportPaths(BB_PATH_ROOT . $asset_path . '/vendor');

            $scssphp->addImportPath(function($path) use ($asset_path) {
                if (!file_exists(BB_PATH_ROOT . $asset_path . '/vendor'))
                {
                    return;
                }
                
                return BB_PATH_ROOT . $asset_path . '/vendor';
            });

            $filename = pathinfo($file, PATHINFO_FILENAME);

            $in     = BB_PATH_ROOT . $asset_path . '/scss/' . $file;
            $out    = BB_PATH_ROOT . $asset_path . '/css/' . $filename . '.css';

            // Only compile if scss file has been modified or force compile has been asked for
            if (!file_exists($out) || filemtime($in) > filemtime($out) || $forceCompile == true)
            {
                $css = $scssphp->compile(file_get_contents($in));
                file_put_contents($out, $css);
            }
        
        } catch (\Leafo\ScssPhp\Exception $e) {
            throw new \Exception($e);
        }


        return 'css/' . $filename . '.css';
    }
}
