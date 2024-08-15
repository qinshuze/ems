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
		$action = $this->ev->url(3);
		if(!method_exists($this,$action))
		$action = "index";
		$this->$action();
		exit;
	}

	public function index()
	{
		$this->course = \PHPEMS\ginkgo::make('course','course');
		$this->content = \PHPEMS\ginkgo::make('content','content');
		$this->position = \PHPEMS\ginkgo::make('position','content');
		$courses = $this->course->getCourseList(array(),1,6);
		$basic = \PHPEMS\ginkgo::make('basic','exam');
		$basics = $basic->getBasicList(array(),1,6);
		$topimgs = $this->position->getPosContentList(array(array("AND","pcposid = 1")),1,5);
		$topnews = $this->position->getPosContentList(array(array("AND","pcposid = 2")),1,10);
		$links = $this->content->getContentList(array(array("AND","contentcatid = 11")),1,10);
		$notices = $this->content->getContentList(array(array("AND","contentcatid = 26")),1,10);
		$banners = $this->content->getContentList(array(array("AND","contentcatid = 2")));

		$where1 = [];
		$where1[] = ['AND', 'type = :type', 'type', 1];
		$tournaments1 = $basic->getTournamentList($where1, 1, 6)['data'];

		$where2 = [];
		$where2[] = ['AND', 'type = :type', 'type', 2];
		$tournaments2 = $basic->getTournamentList($where2, 1, 6)['data'];

		$this->tpl->assign('tournaments1',$tournaments1);
		$this->tpl->assign('tournaments2',$tournaments2);
		$this->tpl->assign('notices',$notices);
		$this->tpl->assign('links',$links);
		$this->tpl->assign('courses',$courses);
		$this->tpl->assign('basics',$basics);
		$this->tpl->assign('topimgs',$topimgs);
		$this->tpl->assign('topnews',$topnews);
		$this->tpl->assign('banners',$banners);
		$this->tpl->display('index');
	}
}


?>
