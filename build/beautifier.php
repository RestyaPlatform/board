<?php
/**
 * Task class for beautifying PHP files
 */
class Beautify
{
    /**
     * Override main
     *
     * @access public
     */
    function __construct($working_path = null)
    {
		set_include_path(get_include_path() . PATH_SEPARATOR . 'D:\Program Files\xampp\php\pear\\');
        if (!@include_once 'PHP/Beautifier.php') {
            echo 'PEAR PHP Beautifier not found';
            exit(1);
        }
        $this->oBeautifier1 = new PHP_Beautifier();
        $this->oBeautifier2 = new PHP_Beautifier();
        if (is_file($working_path)) {
            $this->__beautify_file($working_path);
        } else {
            $this->__beautify_recursive($working_path);
        }
    }
    function __beautify_recursive($dir)
    {
        $handle = opendir($dir);
        while (false !== ($readdir = readdir($handle))) {
            if ($readdir != '.' && $readdir != '..' && $readdir != '.svn') {
                $path = $dir . DIRECTORY_SEPARATOR . $readdir;
                // @todo need to handle dynamically
                if (is_dir($path) && !in_array($readdir, array(
                    'vendors'
                ))) {
                    $this->__beautify_recursive($path);
                }
                if (is_file($path) && (strpos($path, '.php') !== false)) {
                    $this->oBeautifier1->addFilter('Lowercase');
                    $this->oBeautifier1->setInputFile($path);
                    $this->oBeautifier1->process();
                    //
                    $this->oBeautifier2->addFilter('Pear');
                    $this->oBeautifier2->addFilter('ArrayNested');
                    $this->oBeautifier2->setIndentChar(' ');
                    $this->oBeautifier2->setIndentNumber(4);
                    $this->oBeautifier2->setNewLine("\n");
                    $this->oBeautifier2->setInputString($this->oBeautifier1->get());
                    $this->oBeautifier2->process();
                    file_put_contents($path, $this->oBeautifier2->get());
                }
            }
        }
        closedir($handle);
    }
    function __beautify_file($path)
    {
        if (is_file($path) && (strpos($path, '.php') !== false)) {
            $this->oBeautifier1->addFilter('Lowercase');
            $this->oBeautifier1->setInputFile($path);
            $this->oBeautifier1->process();
            //
            $this->oBeautifier2->addFilter('Pear');
            $this->oBeautifier2->addFilter('ArrayNested');
            $this->oBeautifier2->setIndentChar(' ');
            $this->oBeautifier2->setIndentNumber(4);
            $this->oBeautifier2->setNewLine("\n");
            $this->oBeautifier2->setInputString($this->oBeautifier1->get());
            $this->oBeautifier2->process();
            file_put_contents($path, $this->oBeautifier2->get());
        }
    }
}
$beautify = new Beautify($argv[1]);
