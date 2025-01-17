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

	private function selectexams()
	{
		$search = $this->ev->get('search');
		$useframe = $this->ev->get('useframe');
		$target = $this->ev->get('target');
		$page = $this->ev->get('page');
		$page = $page > 0?$page:1;
		$this->pg->setUrlTarget('modal-body" class="ajax');
		$args = array();
		if($search)
		{
			if($search['subjectid'])$args[] = array("AND","examsubject = :examsubject",'examsubject',$search['subjectid']);
		}
		if(!count($args))$args = 1;
		$exams = $this->exam->getExamSettingList($args,$page,10);
		$subjects = $this->basic->getSubjectList();
		$this->tpl->assign('subjects',$subjects);
		$this->tpl->assign('target',$target);
		$this->tpl->assign('exams',$exams);
		$this->tpl->display('exams_ajax');
	}

	private function delexam()
	{
		$examid = $this->ev->get('examid');
		$page = $this->ev->get('page');
		$this->exam->delExamSetting($examid);
		$message = array(
			'statusCode' => 200,
			"message" => "操作成功",
			"callbackType" => "forward",
		    "forwardUrl" => "index.php?exam-teach-exams&page={$page}{$u}"
		);
		exit(json_encode($message));
	}

	private function ajax()
	{
		switch($this->ev->url(4))
		{
			default:
			$subjectid = $this->ev->get('subjectid');
			$type = $this->ev->get('type');
			if($subjectid)
			{
				$basic = $this->basic->getBasicBySubjectId($subjectid);
				$questypes = $this->basic->getQuestypeList();
				$this->tpl->assign('questypes',$questypes);
				$this->tpl->assign("type",$type);
				$this->tpl->assign("subjectid",$subjectid);
				$this->tpl->assign("basic",$basic);
				$this->tpl->display('exams_ajaxsetting');
			}
		}
	}

	private function score()
	{
		$examid = $this->ev->get('examid');
		$exam = $this->exam->getExamSettingById($examid);
		$questypes = $this->basic->getQuestypeList();
		$this->tpl->assign("questypes",$questypes);
		if($this->ev->get('scoreself'))
		{
			$score = $this->ev->get('score');
			$exam['examsetting']['scores'] = $score;
			$this->exam->modifyExamSetting($examid,array('examsetting' => $exam['examsetting']));
			$message = array(
				'statusCode' => 200,
				"message" => "操作成功",
				"callbackType" => "forward",
				"forwardUrl" => "reload"
			);
			\PHPEMS\ginkgo::R($message);
		}
		else
		{
			foreach($exam['examquestions'] as $key => $p)
			{
				$qids = '';
				$qrids = '';
				if($p['questions'])
				{
					$qids = trim($p['questions']," ,");
				}
				if($qids)
				{
					$questions[$key] = $this->exam->getQuestionListByIds($qids);
				}
				if($p['rowsquestions'])
				{
					$qrids = trim($p['rowsquestions']," ,");
				}
				if($qrids)
				{
					$qrids = explode(",",$qrids);
					foreach($qrids as $t)
					{
						$qr = $this->exam->getQuestionRowsById($t);
						if($qr)
						{
							$questionrows[$key][$t] = $qr;
						}
					}
				}
			}
			$exam['examquestions'] = array('questions'=>$questions,'questionrows'=>$questionrows);
			$this->tpl->assign("exam",$exam);
			$this->tpl->display('exams_scoreself');
		}
	}

	private function del()
	{
		$page = $this->ev->get('page');
		$examid = $this->ev->get('examid');
		$this->exam->delExamSetting($examid);
		$message = array(
			'statusCode' => 200,
			"message" => "操作成功",
			"callbackType" => "forward",
		    "forwardUrl" => "index.php?exam-teach-exams&page={$page}{$u}"
		);
		exit(json_encode($message));
	}

	private function autopage()
	{
		if($this->ev->get('submitsetting'))
		{
			$args = $this->ev->get('args');
			$args['examsetting'] = $args['examsetting'];
			$args['examauthorid'] = $this->_user['userid'];
			$args['examauthor'] = $this->_user['username'];
			$args['examtype'] = 1;
			$this->exam->addExamSetting($args);
			$message = array(
				'statusCode' => 200,
				"message" => "操作成功",
			    "forwardUrl" => "index.php?exam-teach-exams&page={$page}{$u}"
			);
			exit(json_encode($message));
		}
		else
		{
			$subjects = $this->basic->getSubjectList(array(array('AND','find_in_set(subjectid,:subjectid)','subjectid',$this->teachsubjects)));
			$questypes = $this->basic->getQuestypeList();
			$this->tpl->assign('questypes',$questypes);
			$this->tpl->assign('subjects',$subjects);
			$this->tpl->display('exams_auto');
		}
	}

	private function selfpage()
	{
		if($this->ev->get('submitsetting'))
		{
			$args = $this->ev->get('args');
			$args['examsetting'] = $args['examsetting'];
			$args['examauthorid'] = $this->_user['userid'];
			$args['examauthor'] = $this->_user['username'];
			$args['examtype'] = 2;
			$args['examquestions'] = $args['examquestions'];
			$id = $this->exam->addExamSetting($args);
			$message = array(
				'statusCode' => 200,
				"message" => "操作成功",
				"callbackType" => "forward",
			    "forwardUrl" => "index.php?exam-teach-exams-examself&examid={$id}&page={$page}{$u}"
			);
			exit(json_encode($message));
		}
		else
		{
			$subjects = $this->basic->getSubjectList(array(array("AND","find_in_set(subjectid,:subjectid)",'subjectid',$this->teachsubjects)));
			$questypes = $this->basic->getQuestypeList();
			$this->tpl->assign('questypes',$questypes);
			$this->tpl->assign('subjects',$subjects);
			$this->tpl->display('exams_self');
		}
	}

	private function temppage()
	{
		if($this->ev->get('submitsetting'))
		{
			$args = $this->ev->get('args');
			$uploadfile = $this->ev->get('uploadfile');
			if(!$uploadfile)
			{
				$message = array(
					'statusCode' => 300,
					"message" => "请上传即时试卷试题"
				);
				\PHPEMS\ginkgo::R($message);
			}
			$args['examsetting'] = $args['examsetting'];
			$args['examauthorid'] = $this->_user['sessionuserid'];
			$args['examauthor'] = $this->_user['sessionusername'];
			$args['examtype'] = 3;
			setlocale(LC_ALL,'zh_CN');
			$handle = fopen($uploadfile,"r");
			$questions = array();
			$rindex = 0;
			$index = 0;
			while ($data = fgetcsv($handle))
			{
				$targs = array();
				$question = $data;
				if(count($question) >= 5)
				{
					$isqr = intval(trim($question[6]," \n\t"));
					if($isqr)
					{
						$istitle = intval(trim($question[7]," \n\t"));;
						if($istitle)
						{
							$rindex ++;
							$targs['qrid'] = 'qr_'.$rindex;
							$targs['qrtype'] = $question[0];
							$targs['qrquestion'] = $this->ev->addSlashes(htmlspecialchars(iconv("GBK","UTF-8//IGNORE",trim(nl2br($question[1])," \n\t"))));
							$targs['qrcreatetime'] = TIME;
							$questionrows[$targs['qrtype']][intval($rindex - 1)] = $targs;
						}
						else
						{
							$index ++;
							$targs['questionid'] = 'q_'.$index;
							$targs['questiontype'] = $question[0];
							$targs['question'] = $this->ev->addSlashes(htmlspecialchars(iconv("GBK","UTF-8//IGNORE",trim(nl2br($question[1])," \n\t"))));
							$targs['questionselect'] = $this->ev->addSlashes(htmlspecialchars(iconv("GBK","UTF-8//IGNORE",trim(nl2br($question[2])," \n\t"))));
							if(!$targs['questionselect'] && $targs['questiontype'] == 3)
							$targs['questionselect'] = '<p>A、对<p><p>B、错<p>';
							$targs['questionselectnumber'] = $question[3];
							$targs['questionanswer'] = $this->ev->addSlashes(htmlspecialchars(iconv("GBK","UTF-8//IGNORE",trim($question[4]," \n\t"))));
							$targs['questiondescribe'] = $this->ev->addSlashes(htmlspecialchars(iconv("GBK","UTF-8//IGNORE",trim($question[5]," \n\t"))));
							$targs['questioncreatetime'] = TIME;
							$questionrows[$targs['questiontype']][intval($rindex - 1)]['data'][] = $targs;
						}
					}
					else
					{
						$index++;
						$targs['questionid'] = 'q_'.$index;
						$targs['questiontype'] = $question[0];
						$targs['question'] = $this->ev->addSlashes(htmlspecialchars(iconv("GBK","UTF-8//IGNORE",trim(nl2br($question[1])," \n\t"))));
						$targs['questionselect'] = $this->ev->addSlashes(htmlspecialchars(iconv("GBK","UTF-8//IGNORE",trim(nl2br($question[2])," \n\t"))));
						if(!$targs['questionselect'] && $targs['questiontype'] == 3)
						$targs['questionselect'] = '<p>A、对<p><p>B、错<p>';
						$targs['questionselectnumber'] = intval($question[3]);
						$targs['questionanswer'] = $this->ev->addSlashes(htmlspecialchars(iconv("GBK","UTF-8//IGNORE",trim($question[4]," \n\t"))));
						$targs['questiondescribe'] = $this->ev->addSlashes(htmlspecialchars(iconv("GBK","UTF-8//IGNORE",trim($question[5]," \n\t"))));
						$targs['questioncreatetime'] = TIME;
						$questions[$targs['questiontype']][] = $targs;
					}
				}
			}
			$args['examquestions'] = array('questions' => $questions,'questionrows' => $questionrows);
			$id = $this->exam->addExamSetting($args);
			$message = array(
				'statusCode' => 200,
				"message" => "操作成功",
				"callbackType" => "forward",
			    "forwardUrl" => "index.php?exam-teach-exams-examself&examid={$id}&page={$page}{$u}"
			);
			\PHPEMS\ginkgo::R($message);
		}
		else
		{
			$subjects = $this->basic->getSubjectList();
			$questypes = $this->basic->getQuestypeList();
			$this->tpl->assign('questypes',$questypes);
			$this->tpl->assign('subjects',$subjects);
			$this->tpl->display('exams_temp');
		}
	}

	private function selected()
	{
		$show = $this->ev->get('show');
		$questionids = trim($this->ev->get('questionids')," ,");
		$rowsquestionids = trim($this->ev->get('rowsquestionids')," ,");
		if(!$questionids)$questionids = '0';
		if(!$rowsquestionids)$rowsquestionids = '0';
		$questions = $this->exam->getQuestionListByArgs(array(array('AND',"questionstatus = 1"),array('AND',"find_in_set(questionid,:questionid)",'questionid',$questionids)));
		$rowsquestions = array();
		$rowsquestionids = explode(',',$rowsquestionids);
		foreach($rowsquestionids as $p)
		{
			if($p)
			$rowsquestions[$p] = $this->exam->getQuestionRowsByArgs(array(array('AND',"qrstatus = 1"),array('AND',"qrid = :qrid",'qrid',$p)));
		}
		$this->tpl->assign('rowsquestions',$rowsquestions);
		$this->tpl->assign('questions',$questions);
		$this->tpl->assign('show',$show);
		$this->tpl->display('exams_selected');
	}

	private function selectquestions()
	{
		$useframe = $this->ev->get('useframe');
		$search = $this->ev->get('search');
		$page = $this->ev->get('page');
		$page = $page > 0?$page:1;
		$this->pg->setUrlTarget('modal-body" class="ajax');
		if(!$search['questionisrows'])
		{
			$args = array(array("AND","quest2knows.qkquestionid = questions.questionid"),array("AND","questions.questionstatus = '1'"),array("AND","questions.questionparent = 0"),array("AND","quest2knows.qktype = 0") );
			if($search['keyword'])
			{
				$args[] = array("AND","questions.question LIKE :question",'question','%'.$search['keyword'].'%');
			}
			if($search['knowsids'])
			{
				$args[] = array("AND","find_in_set(questions.questionknowsid,:questionknowsid)",'questionknowsid',$search['knowsids']);
			}
			if($search['stime'])
			{
				$args[] = array("AND","questions.questioncreatetime >= :squestioncreatetime",'squestioncreatetime',strtotime($search['stime']));
			}
			if($search['etime'])
			{
				$args[] = array("AND","questions.questioncreatetime <= :equestioncreatetime",'equestioncreatetime',strtotime($search['etime']));
			}
			if($search['questiontype'])
			{
				$args[] = array("AND","questions.questiontype = :questiontype",'questiontype',$search['questiontype']);
			}
			if($search['questionlevel'])
			{
				$args[] = array("AND","questions.questionlevel = :questionlevel",'questionlevel',$search['questionlevel']);
			}
			if($search['questionknowsid'])
			{
				$args[] = array("AND","quest2knows.qkknowsid = :qkknowsid",'qkknowsid',$search['questionknowsid']);
			}
			else
			{
				$tmpknows = '0';
				if($search['questionsectionid'])
				{
					$knows = $this->section->getKnowsListByArgs(array(array("AND","knowsstatus = 1"),array("AND","knowssectionid = :knowssectionid",'knowssectionid',$search['questionsectionid'])));
					foreach($knows as $p)
					{
						if($p['knowsid'])$tmpknows .= ','.$p['knowsid'];
					}
					$args[] = array("AND","find_in_set(quest2knows.qkknowsid,:qkknowsid)",'qkknowsid' ,$tmpknows);
				}
				elseif($search['questionsubjectid'])
				{
					$knows = $this->section->getAllKnowsBySubject($search['questionsubjectid']);
					foreach($knows as $p)
					{
						if($p['knowsid'])$tmpknows .= ','.$p['knowsid'];
					}
					$args[] = array("AND","find_in_set(quest2knows.qkknowsid,:qkknowsid)",'qkknowsid',$tmpknows);
				}
				else
				{
					$knows = $this->section->getAllKnowsBySubjects($this->teachsubjects);
					foreach($knows as $p)
					{
						if($p['knowsid'])$tmpknows .= ','.$p['knowsid'];
					}
					$args[] = array("AND","find_in_set(quest2knows.qkknowsid,:qkknowsid)",'qkknowsid',$tmpknows);
				}
			}
			$questions = $this->exam->getQuestionsList($page,10,$args);
		}
		else
		{
			$args = array(array("AND","quest2knows.qkquestionid = questionrows.qrid"),array("AND","questionrows.qrstatus = '1'"));
			if($search['keyword'])
			{
				$args[] = array("AND","questionrows.qrquestion LIKE :qrquestion",'qrquestion','%'.$search['keyword'].'%');
			}
			if($search['questiontype'])
			{
				$args[] = array("AND","questionrows.qrtype = :qrtype",'qrtype',$search['questiontype']);
			}
			if($search['stime'])
			{
				$args[] = array("AND","questionrows.qrtime >= :stime",'stime',strtotime($search['stime']));
			}
			if($search['etime'])
			{
				$args[] = array("AND","questionrows.qrtime <= :etime",'etime',strtotime($search['etime']));
			}
			if($search['qrlevel'])
			{
				$args[] = array("AND","questionrows.qrlevel = :qrlevel",'qrlevel',$search['qrlevel']);
			}
			if($search['questionknowsid'])
			{
				$args[] = array("AND","quest2knows.qkknowsid = :qkknowsid",'qkknowsid',$search['questionknowsid']);
			}
			else
			{
				$tmpknows = '0';
				if($search['questionsectionid'])
				{
					$knows = $this->section->getKnowsListByArgs(array(array("AND","knowsstatus = 1"),array("AND","knowssectionid = :knowssectionid",'knowssectionid',$search['questionsectionid'])));
					foreach($knows as $p)
					{
						if($p['knowsid'])$tmpknows .= ','.$p['knowsid'];
					}
					$args[] = array("AND","find_in_set(quest2knows.qkknowsid,:qkknowsid)",'qkknowsid' ,$tmpknows);
				}
				elseif($search['questionsubjectid'])
				{
					$knows = $this->section->getAllKnowsBySubject($search['questionsubjectid']);
					foreach($knows as $p)
					{
						if($p['knowsid'])$tmpknows .= ','.$p['knowsid'];
					}
					$args[] = array("AND","find_in_set(quest2knows.qkknowsid,:qkknowsid)",'qkknowsid',$tmpknows);
				}
				else
				{
					$knows = $this->section->getAllKnowsBySubjects($this->teachsubjects);
					foreach($knows as $p)
					{
						if($p['knowsid'])$tmpknows .= ','.$p['knowsid'];
					}
					$args[] = array("AND","find_in_set(quest2knows.qkknowsid,:qkknowsid)",'qkknowsid',$tmpknows);
				}
			}
			$questions = $this->exam->getQuestionrowsList($page,10,$args);
		}
		if($useframe)$questions['pages'] = str_replace('&useframe=1','',$questions['pages']);
		$questypes = $this->basic->getQuestypeList();
		$sections = $this->section->getSectionListByArgs(array(array("AND","sectionsubjectid = :sectionsubjectid","sectionsubjectid",$search['questionsubjectid'])));
		$knows = $this->section->getKnowsListByArgs(array(array("AND","knowsstatus = 1"),array("AND","knowssectionid = :knowssectionid","knowssectionid",$search['questionsectionid'])));
		//$this->tpl->assign('subjects',$subjects);
		$this->tpl->assign('search',$search);
		$this->tpl->assign('sections',$sections);
		$this->tpl->assign('knows',$knows);
		$this->tpl->assign('questypes',$questypes);
		$this->tpl->assign('questiontype',$search['questiontype']);
		$this->tpl->assign('questions',$questions);
		$this->tpl->assign('useframe',$useframe);
		$this->tpl->display('selectquestions');
	}

	private function downloadexam()
	{
		$examid = $this->ev->get('examid');
		$r = $this->exam->getExamSettingById($examid);
		$this->tpl->assign("setting",$r);
		$questions = array();
		$questionrows = array();
		foreach($r['examquestions'] as $key => $p)
		{
			$qids = '';
			$qrids = '';
			if($p['questions'])$qids = trim($p['questions']," ,");
			if($qids)
				$questions[$key] = $this->exam->getQuestionListByIds($qids);
			if($p['rowsquestions'])$qrids = trim($p['rowsquestions']," ,");
			if($qrids)
			{
				$qrids = explode(",",$qrids);
				foreach($qrids as $t)
				{
					$qr = $this->exam->getQuestionRowsById($t);
					if($qr)
						$questionrows[$key][$t] = $qr;
				}
			}
		}
		$args['examsessionquestion'] = array('questions'=>$questions,'questionrows'=>$questionrows);
		$args['examsessionsetting'] = $r;
		$questype = $this->basic->getQuestypeList();
		$this->tpl->assign('questype',$questype);
		$this->tpl->assign("sessionvars",$args);
		$content = $this->tpl->fetchExeCnt('exam_download');
		$content = \PHPEMS\ginkgo::make('word')->WordMake($content);
		$this->files->mdir("data/word/");
		$fname = 'data/word/'.uniqid().".doc";//转换好生成的word文件名编码
		$fp = fopen($fname, 'w');//打开生成的文档
		fwrite($fp, $content);//写入包保存文件
		fclose($fp);
		$message = array(
			'statusCode' => 200,
			"message" => "试卷导出成功，转入下载页面，如果浏览器没有相应，请<a href=\"{$fname}\">点此下载</a>",
			"callbackType" => 'forward',
			"forwardUrl" => "{$fname}"
		);
		exit(json_encode($message));
	}

	private function preview()
	{
		$examid = $this->ev->get('examid');
		$r = $this->exam->getExamSettingById($examid);
		$this->tpl->assign("setting",$r);
		if($r['examtype'] == 2)
		{
			$questions = array();
			$questionrows = array();
			foreach($r['examquestions'] as $key => $p)
			{
				$qids = '';
				$qrids = '';
				if($p['questions'])$qids = trim($p['questions']," ,");
				if($qids)
				$questions[$key] = $this->exam->getQuestionListByIds($qids);
				if($p['rowsquestions'])$qrids = trim($p['rowsquestions']," ,");
				if($qrids)
				{
					$qrids = explode(",",$qrids);
					foreach($qrids as $t)
					{
						$qr = $this->exam->getQuestionRowsById($t);
						if($qr)
						$questionrows[$key][$t] = $qr;
					}
				}
			}
			$args['examsessionquestion'] = array('questions'=>$questions,'questionrows'=>$questionrows);
			$args['examsessionsetting'] = $r;
			$args['examsessionstarttime'] = TIME;
			$args['examsession'] = $r['exam'];
			$args['examsessionscore'] = 0;
			$args['examsessiontime'] = $r['examsetting']['examtime'];
			$args['examsessiontype'] = 2;
			$args['examsessionkey'] = $r['examid'];
			$args['examsessionissave'] = 0;
		}
		else
		{
			$args['examsessionquestion'] = array('questions'=>$r['examquestions']['questions'],'questionrows'=>$r['examquestions']['questionrows']);
			$args['examsessionsetting'] = $r;
			$args['examsessionstarttime'] = TIME;
			$args['examsession'] = $r['exam'];
			$args['examsessiontime'] = $r['examsetting']['examtime'];
			$args['examsessiontype'] = 2;
			$args['examsessionkey'] = $r['examid'];
		}
		$questype = $this->basic->getQuestypeList();
		$this->tpl->assign('questype',$questype);
		$this->tpl->assign("sessionvars",$args);
		$this->tpl->display('exams_paper');
	}

	private function modify()
	{
		$search = $this->ev->get('search');
		if($this->ev->get('submitsetting'))
		{
			$examid = $this->ev->get('examid');
			$args = $this->ev->get('args');
			$args['examsetting'] = $args['examsetting'];
			$args['examquestions'] = $args['examquestions'];
			$this->exam->modifyExamSetting($examid,$args);
			$message = array(
				'statusCode' => 200,
				"message" => "操作成功",
				"callbackType" => "forward",
			    "forwardUrl" => "index.php?exam-teach-exams&page={$page}{$u}"
			);
			exit(json_encode($message));
		}
		else
		{
			$examid = $this->ev->get('examid');
			$exam = $this->exam->getExamSettingById($examid);
			$subjects = $this->basic->getSubjectList(array(array('AND','find_in_set(subjectid,:subjectid)','subjectid',$this->teachsubjects)));
			$questypes = $this->basic->getQuestypeList();
			foreach($exam['examquestions'] as $key => $p)
			{
				$exam['examnumber'][$key] = $this->exam->getExamQuestionNumber($p);
			}
			$this->tpl->assign('search',$search);
			$this->tpl->assign('subjects',$subjects);
			$this->tpl->assign('exam',$exam);
			$this->tpl->assign('questypes',$questypes);
			if($exam['examtype'] == 1)
			$this->tpl->display('exams_modifyauto');
			else
			$this->tpl->display('exams_modifyself');
		}
	}

	private function index()
	{
		$search = $this->ev->get('search');
		$page = $this->ev->get('page');
		$page = $page > 0?$page:1;
		$args = array(array('AND','find_in_set(examsubject,:examsubject)','examsubject',$this->teachsubjects));
		if($search)
		{
			if($search['examsubject'])$args[] = array('AND',"examsubject = :sexamsubject",'sexamsubject',$search['examsubject']);
			if($search['examtype'])$args[] = array('AND',"examtype = :examtype","examtype",$search['examtype']);
		}
		if(!count($args))$args = 1;
		$exams = $this->exam->getExamSettingList($args,$page,10);
		$subjects = $this->basic->getSubjectList(array(array("AND","find_in_set(subjectid,:subjectid)",'subjectid',$this->teachsubjects)));
		//$subjects = $this->basic->getSubjectList("subjectid IN ({$this->teachsubjects})");
		$this->tpl->assign('subjects',$subjects);
		$this->tpl->assign('exams',$exams);
		$this->tpl->display('exams');
	}
}


?>
