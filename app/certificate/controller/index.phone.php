<?php
 namespace PHPEMS;
/*
 * Created on 2016-5-19
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */
class action extends app
{
	public function display()
	{
		$this->config = \PHPEMS\ginkgo::make('config','ce');
		$action = $this->ev->url(3);
		if(!method_exists($this,$action))
		$action = "index";
		$this->$action();
		exit;
	}

	private function index()
	{
		$page = intval($this->ev->get('page'));
		$args = array();
		$args[] = array("AND","cequserid = :cequserid","cequserid",$this->_user['sessionuserid']);
		$certificates = $this->ce->getCeQueueList($args,$page,10);
		$this->tpl->assign('certificates',$certificates);
		$this->tpl->assign('status',$this->config->status);
		$this->tpl->assign('page',$page);
		$this->tpl->display('index');
	}
}


?>
