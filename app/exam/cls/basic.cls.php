<?php
 namespace PHPEMS;
/*
 * Created on 2011-11-21
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 * 对地区进行操作
 */
class basic_exam
{
	public $G;

	public function __construct()
	{
		
		$this->sql = \PHPEMS\ginkgo::make('sql');
		$this->pdosql = \PHPEMS\ginkgo::make('pdosql');
		$this->db = \PHPEMS\ginkgo::make('pepdo');
		$this->pg = \PHPEMS\ginkgo::make('pg');
		$this->ev = \PHPEMS\ginkgo::make('ev');
	}

	public function getBestBasics()
	{
		$t = TIME - 30*24*2400;
		$data = array("count(*) AS number,ehbasicid",'examhistory',array(array("AND","ehstarttime >= :ehstarttime",'ehstarttime',$t)),"ehbasicid","number DESC",6);
		$sql = $this->pdosql->makeSelect($data);
		$r = $this->db->fetchAll($sql);
		$ids = array();
		$number = array();
		foreach($r as $p)
		{
			$ids[] = $p['ehbasicid'];
			$number[$p['ehbasicid']] = $p['number'];
		}
		$ids = implode(',',$ids);
		if(!$ids)
		return false;
		$rs = array();
		$rs['basic'] = $this->getBasicsByArgs(array(array("AND","find_in_set(basicid,:ids)",'ids',$ids)));
		$rs['number'] = $number;
		return $rs;
	}

	public function getOpenBasicsByUserid($userid)
	{
		$data = array(false,array('openbasics','basic'),array(array("AND","openbasics.obuserid = :userid",'userid',$userid),array("AND","basic.basicclosed = 0"),array("AND","openbasics.obbasicid = basic.basicid"),array("AND","openbasics.obendtime > :obendtime",'obendtime',TIME)),false,"openbasics.obendtime DESC,obid DESC",false);
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetchAll($sql,'obbasicid',array('basicknows','basicsection','basicexam'));
	}

	public function openBasic($args)
	{
		$data = array('openbasics',array(array("AND","obuserid = :obuserid",'obuserid',$args['obuserid']),array("AND","obbasicid = :obbasicid",'obbasicid',$args['obbasicid'])));
		$sql = $this->pdosql->makeDelete($data);
		$this->db->exec($sql);
		$args['obtime'] = TIME;
		$data = array('openbasics',$args);
		$sql = $this->pdosql->makeInsert($data);
		return $this->db->exec($sql);
	}

	public function delOpenBasic($obid)
	{
		$data = array('openbasics',array(array("AND","obid = :obid",'obid',$obid)));
		$sql = $this->pdosql->makeDelete($data);
		return $this->db->exec($sql);
	}

	public function delOpenPassBasic($userid)
	{
		$data = array('openbasics',array(array("AND","obuserid = :obuserid",'obuserid',$userid),array("AND","obendtime <= :obendtime",'obendtime',TIME)));
		$sql = $this->pdosql->makeDelete($data);
		return $this->db->exec($sql);
	}

	public function getOpenBasicMember($args,$page,$number = 20,$order = 'obtime DESC,obid DESC')
	{
		$args[] = array("AND","openbasics.obuserid = user.userid");
		$data = array(
			'select' => false,
			'table' => array('openbasics','user'),
			'query' => $args,
			'orderby' => $order
		);
		$r = $this->db->listElements($page,$number,$data);
		return $r;
	}

	public function getOpenBasicNumber($basicid)
	{
		$data = array("count(*) as number",'openbasics',array(array("AND","obbasicid = :obbasicid",'obbasicid',$basicid),array("AND","obendtime >= :obendtime",'obendtime',TIME)));
		$sql = $this->pdosql->makeSelect($data);
		$r = $this->db->fetch($sql);
		return $r['number'];
	}

	public function getOpenBasicById($obid)
	{
		$data = array(false,'openbasics',array(array("AND","obid = :obid",'obid',$obid)));
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetch($sql);
	}

	public function getOpenBasicByUseridAndBasicid($userid,$basicid)
	{
		$data = array(false,'openbasics',array(array("AND","obuserid = :obuserid",'obuserid',$userid),array("AND","obbasicid = :obbasicid",'obbasicid',$basicid),array("AND","obendtime > :obendtime",'obendtime',TIME)));
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetch($sql);
	}

	public function getOpenBasicIds(array $userIds, array $basicIds = [])
	{
		$userIds = array_map('intval', $userIds);
		$userIdsPlaceholder = rtrim(str_repeat('?,', count($userIds)), ',');
		$sql = "SELECT obbasicid as basic_id, obuserid as user_id FROM {$this->pdosql->tablepre}openbasics WHERE obuserid IN ($userIdsPlaceholder) AND obendtime > ?";

		$params = array_merge($userIds, [time()]);
		if ($basicIds) {
			$basicIds = array_map('intval', $basicIds);
			$basicIdsPlaceholder = rtrim(str_repeat('?,', count($basicIds)), ',');
			$sql .= " AND obbasicid IN ($basicIdsPlaceholder)";
			$params = array_merge($params,$basicIds);
		}

		/** @var \PDO $pdo */
		$pdo = $this->db->getPdo();
		$stmt = $pdo->prepare($sql);
		$stmt->execute($params);

		return $stmt->fetchAll(\PDO::FETCH_ASSOC);
	}

	//获取题库列表
	//参数：无
	//返回值：题库列表数组
	public function getSubjectList($args = 1)
	{
		$data = array(false,'subject',$args,false,false);
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetchAll($sql,'subjectid','subjectsetting');
	}

	//根据题库查询
	//参数：题库名称字符串
	//返回值：题库信息数组
	public function getSubjectByName($subject)
	{
		$data = array(false,'subject',array(array("AND","subject = :subject",'subject',$subject)));
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetch($sql,'subjectsetting');
	}

	//根据题库ID查询题库信息
	//参数：题库ID整数
	//返回值：题库信息数组
	public function getSubjectById($subjectid)
	{
		$data = array(false,'subject',array(array("AND","subjectid = :subjectid",'subjectid',$subjectid)));
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetch($sql,'subjectsetting');
	}

	//修改题库信息
	//参数：题库ID，修改的信息数组
	//返回值：true
	public function modifySubject($subjectid,$args)
	{
		$data = array('subject',$args,array(array("AND","subjectid = :subjectid",'subjectid',$subjectid)));
		$sql = $this->pdosql->makeUpdate($data);
		$this->db->exec($sql);
		return true;
	}

	//增加题库
	//参数：题库ID，修改的信息数组
	//返回值：true
	public function addSubject($args)
	{
		$data = array('subject',$args);
		$sql = $this->pdosql->makeInsert($data);
		$this->db->exec($sql);
		return $this->db->lastInsertId();
	}

	//删除题库
	//参数：题库ID
	//返回值：受影响的记录数
	public function delSubject($id)
	{
		$data = array('subject',array(array("AND","subjectid = :subjectid",'subjectid',$id)));
		$sql = $this->pdosql->makeDelete($data);
		return $this->db->exec($sql);
		//return $this->db->affectedRows();
	}

	//设置地区配置信息
	//参数：题库ID，配置信息数组
	//返回值：受影响的记录数
	public function setSubjectConfig($id,$args)
	{
		$data = array('subject',$args,array(array("AND","subjectid = :subjectid",'subjectid',$id)));
		$sql = $this->pdosql->makeUpdate($data);
		return $this->db->exec($sql);
		//return $this->db->affectedRows();
	}

	//通过获取地区、题库、代码对应关系列表
	//参数：页码，每页显示数量，查询信息数组
	//返回值：配置信息数组
	public function getBasicList($args = array(),$page,$number = 20,$orderby = 'basicid desc')
	{
		$page = $page > 0?$page:1;
		$r = array();
		$data = array(false,'basic',$args,false,$orderby,array(intval($page-1)*$number,$number));
		$sql = $this->pdosql->makeSelect($data);
		$r['data'] = $this->db->fetchAll($sql,'basicid',array('basicknows','basicsection','basicexam'));
		$data = array('count(*) AS number','basic',$args);
		$sql = $this->pdosql->makeSelect($data);
		$t = $this->db->fetch($sql);
		$pages = $this->pg->outPage($this->pg->getPagesNumber($t['number'],$number),$page);
		$r['pages'] = $pages;
		$r['number'] = $t['number'];
		return $r;
	}

	//通过ID获取地区、题库、代码对应关系
	//参数：页码，每页显示数量，配置信息数组
	//返回值：配置信息数组
	public function getBasicById($id)
	{
		$data = array(false,'basic',array(array("AND","basicid = :basicid",'basicid',$id)));
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetch($sql,array('basicknows','basicsection','basicexam'));
	}

	public function getBasicByArgs($args)
	{
		$data = array(false,'basic',$args);
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetch($sql,array('basicknows','basicsection','basicexam'));
	}

	public function getBasicsByArgs($args,$number = false,$ordeby = 'basicid desc')
	{
		$data = array(false,'basic',$args,false,$ordeby,$number);
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetchAll($sql,'basicid',array('basicknows','basicsection','basicexam'));
	}

	//通过考试ID获取地区、题库、代码对应关系
	//参数：考试ID
	//返回值：对应关系数组
	public function getBasicByExamid($id)
	{
		$data = array(false,array('basic','subject'),array(array("AND","basicexamid = :basicexamid",'basicexamid',$id),array("AND","basic.basicsubjectid = subject.subjectid")));
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetchAll($sql,array('basicknows','basicsection','basicexam'));
	}

	//通过多个考试ID获取地区、题库、代码对应关系
	//参数：多个考试ID，以英文逗号连接
	//返回值：对应关系列表数组
	public function getBasicsByApi($id)
	{
		if(!$id)return false;
		$data = array(false,'basic',array(array("AND","find_in_set(basicexamid,:basicexamid)","basicexamid",$id)),false,"basicid ASC",false);
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetchAll($sql,'basicid',array('basicknows','basicsection','basicexam'));
	}

	//添加地区、题库、代码对应关系
	//参数：要添加的对应关系形成的数组
	//返回值：插入的记录ID
	public function addBasic($args)
	{
		$data = array('basic',$args);
		$sql = $this->pdosql->makeInsert($data);
		$this->db->exec($sql);
		return $this->db->lastInsertId();
	}

	/**
	 * 根据赛事id获取考场
	 * @param int $tournamentId
	 * @return mixed
	 */
	public function getBasicByTournamentId(int $tournamentId)
	{
		$sql = "SELECT * FROM {$this->pdosql->tablepre}basic WHERE tournament_id = :id";

		/** @var \PDO $pdo */
		$pdo = $this->db->getPdo();
		$stmt = $pdo->prepare($sql);
		$stmt->execute([':id' => $tournamentId]);

		return $stmt->fetchAll(\PDO::FETCH_ASSOC);
	}


    /**
     * 获取赛事列表
     * @param array $args
     * @param int $page
     * @param int $number
     * @param string $orderby
     * @return mixed
     */
	public function getTournamentList(array $args = [], int $page = 1, int $number = 20, string $orderby = 'id desc')
	{
		$r = ['data' => []];

		$data = array('count(*) AS number','tournament',$args);
		$sql = $this->pdosql->makeSelect($data);
		$t = $this->db->fetch($sql);
		$pages = $this->pg->outPage($this->pg->getPagesNumber($t['number'],$number),$page);
		$r['pages'] = $pages;
		$r['number'] = $t['number'];

		if ($t['number'] && $t['number'] > 0) {
			$data = [false,'tournament',$args,false,$orderby,
				[intval($page-1)*$number,$number]
			];
			$sql = $this->pdosql->makeSelect($data);
			$r['data'] = $this->db->fetchAll($sql);
		}

		return $r;
	}

	/**
	 * 根据题库id获取章节
	 * @param int $id
	 * @return array|false
	 */
	public function getSectionBySubjectId(int $id, string $fields = '*')
	{
		$sql = "SELECT $fields FROM {$this->pdosql->tablepre}sections WHERE sectionsubjectid = :id";

		/** @var \PDO $pdo */
		$pdo = $this->db->getPdo();
		$stmt = $pdo->prepare($sql);
		$stmt->execute([':id' => $id]);

		return $stmt->fetchAll(\PDO::FETCH_ASSOC);
	}

	/**
	 * 根据章节id获取知识点
	 * @param int $id
	 * @return array|false
	 */
	public function getKnowBySectionId(int $id, string $fields = '*')
	{
		$sql = "SELECT $fields FROM {$this->pdosql->tablepre}knows WHERE knowssectionid = :id";

		/** @var \PDO $pdo */
		$pdo = $this->db->getPdo();
		$stmt = $pdo->prepare($sql);
		$stmt->execute([':id' => $id]);

		return $stmt->fetchAll(\PDO::FETCH_ASSOC);
	}

	/**
	 * 添加赛事
	 * @param $args
	 * @return int|false
     */
	public function addTournament($args)
	{
		$tournamentData = $args;
		unset($tournamentData['content']);

		$data = array('tournament', $tournamentData);
		$sql = $this->pdosql->makeInsert($data);
		$this->db->beginTransaction();

		$res = $this->db->exec($sql);
		if (!$res) {
			$this->db->rollback();
			return false;
		}

		$id = $this->db->lastInsertId();
		$contentSql = $this->pdosql->makeInsert([
			'tournament_content', ['tournament_id' => $id, 'content' => $args['content']]
		]);

		$res = $this->db->exec($contentSql);
		if (!$res) {
			$this->db->rollback();
			return false;
		}

		$this->db->commit();
		return intval($id);
	}

	/**
	 * 更新赛事
	 * @param $id
	 * @param $args
	 * @return bool
	 */
	public function modifyTournament($id, $args)
	{
		$tournamentData = $args;
		unset($tournamentData['content']);

		$data = array('tournament', $tournamentData, array(array("AND","id = :id",'id',$id)));
		$sql = $this->pdosql->makeUpdate($data);

		$this->db->beginTransaction();
		$res = $this->db->exec($sql);
		if (!$res) {
			$this->db->rollback();
			return false;
		}

		$contentSql = $this->pdosql->makeUpdate([
			'tournament_content', ['content' => $args['content']],
			[["AND","tournament_id = :tournament_id",'tournament_id',$id]]
		]);

		$res = $this->db->exec($contentSql);
		if (!$res) {
			$this->db->rollback();
			return false;
		}

		$this->db->commit();
		return $res;
	}


	/**
	 * 删除赛事
	 * @param int[] $ids
	 * @return int|false
	 */
	public function delTournament(array $ids)
	{
		$ids = array_map('intval', $ids);
		$strIds = rtrim(str_repeat('?,', count($ids)), ',');
		$this->db->beginTransaction();

		$contentSql = $this->pdosql->makeDelete(['tournament_content', [['AND', "tournament_id IN ($strIds)", 'tournament_id', $ids]]]);
		$contentSql['v'] = $contentSql['v']['tournament_id'];
		$res = $this->db->exec($contentSql);

		if (!$res) {
			$this->db->rollback();
			return false;
		}

		$sql = $this->pdosql->makeDelete(['tournament', [['AND', "id IN ($strIds)", 'id', $ids]]]);
		$sql['v'] = $sql['v']['id'];
		$res = $this->db->exec($sql);
		if (!$res) {
			$this->db->rollback();
			return false;
		}

		$this->db->commit();
		return $res;
	}

	/**
	 * 获取赛事详情
	 * @param int $id
	 * @return mixed
	 */
	public function getTournamentDetails(int $id)
	{
		$sql = "SELECT t.*,tc.content FROM {$this->pdosql->tablepre}tournament as t LEFT JOIN {$this->pdosql->tablepre}tournament_content as tc ON tc.tournament_id = t.id WHERE t.id = :id";

		/** @var \PDO $pdo */
		$pdo = $this->db->getPdo();
		$stmt = $pdo->prepare($sql);
		$stmt->execute([':id' => $id]);

		return $stmt->fetch(\PDO::FETCH_ASSOC);
	}

	/**
	 * 根据id获取赛事
	 * @param int[] $ids
	 * @param string $fields
	 * @return array|false
	 */
	public function getTournamentByIds(array $ids, string $fields = '*')
	{
		$pre = $this->pdosql->tablepre;
		$ids = array_map('intval', $ids);
		$strIds = rtrim(str_repeat('?,', count($ids)), ',');

		$sql = "SELECT * FROM {$pre}tournament WHERE id IN ($strIds)";

		/** @var \PDO $pdo */
		$pdo = $this->db->getPdo();
		$stmt = $pdo->prepare($sql);
		$stmt->execute($ids);

		return $stmt->fetchAll(\PDO::FETCH_ASSOC);
	}

	//设置地区、题库、代码对应关系
	//参数：要添加的对应关系形成的数组
	//返回值：插入的记录ID
	public function setBasicConfig($id,$args)
	{
		$data = array('basic',$args,array(array("AND","basicid = :basicid",'basicid',$id)));
		$sql = $this->pdosql->makeUpdate($data);
		return $this->db->exec($sql);
		//$this->db->affectedRows();
	}

	//删除地区、题库、代码对应关系
	//参数：对应关系ID
	//返回值：受影响的记录数
	public function delBasic($id)
	{
		$data = array('basic',array(array("AND","basicid = :basicid",'basicid',$id)));
		$sql = $this->pdosql->makeDelete($data);
		return $this->db->exec($sql);
		//$this->db->affectedRows();
	}

	//获取题型列表
	//参数：查询条件数组
	//返回值：题型列表数组
	public function getQuestypeList($args = 1)
	{
		$data = array(false,'questype',$args,false,false,false);
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetchAll($sql,'questid');
	}

	//根据题型名查询
	//参数：题型名称字符串
	//返回值：题型数组
	public function getQuestypeByName($questype)
	{
		$data = array(false,'questype',array(array("AND","questype = :questype",'questype',$questype)));
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetch($sql);
	}

	//根据题型ID查询
	//参数：题型ID
	//返回值：题型数组
	public function getQuestypeById($questid)
	{
		$data = array(false,'questype',array(array("AND","questid = :questid",'questid',$questid)));
		$sql = $this->pdosql->makeSelect($data);
		return $this->db->fetch($sql);
	}

	//增加题型
	//参数：题型信息数组
	//返回值：插入的ID
	public function addQuestype($args)
	{
		$data = array('questype',$args);
		$sql = $this->pdosql->makeInsert($data);
		$this->db->exec($sql);
		return $this->db->lastInsertId();
	}

	//修改题型
	//参数：题型ID，修改信息数组
	//返回值：受影响的记录数
	public function modifyQuestype($questid,$args)
	{
		$data = array('questype',$args,array(array("AND","questid = :questid",'questid',$questid)));
		$sql = $this->pdosql->makeUpdate($data);
		return $this->db->exec($sql);
		//return $this->db->affectedRows();
	}

	//删除题型
	//参数：题型ID
	//返回值：受影响的记录数
	public function delQuestype($questid)
	{
		$data = array('questype',array(array("AND","questid = :questid",'questid',$questid)));
		$sql = $this->pdosql->makeDelete($data);
		return $this->db->exec($sql);
		//return $this->db->affectedRows();
	}

}

?>
