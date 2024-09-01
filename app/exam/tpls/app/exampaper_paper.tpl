{x2;include:header}
<style>
	.btn.btn-default.qindex.btn-primary {
		background-color: coral;
		border-color: #f56733;
	}
</style>
<body>
<div class="container-fluid">
	<div class="row-fluid">
		<div class="pages">
			<div class="header navbar-fixed-top">
				<div class="nav">
					<div class="col-xs-9">
						<ul class="list-unstyled list-inline">
							<li>
								<h3 class="logo">{x2;$sessionvars['examsession']}</h3>
							</li>
						</ul>
					</div>
					<div class="col-xs-3">
						<ul class="list-unstyled list-inline">
							<li>
								<h3 class="logo"><span id="timer_h">00</span>：<span id="timer_m">00</span>：<span id="timer_s">00</span></h3>
							</li>
							<li class="pull-right">
								<a href="javascript:;" onclick="javascript:$('#submodal').modal();" class="menu">
									<span class="glyphicon glyphicon-print"></span> 交卷
								</a>
							</li>
						</ul>
					</div>
				</div> 
			</div>
			<div class="content fixtop">
				<div class="col-xs-3">
					<div class="content-box padding" id="questionindex" data-spy="affix">
                        {x2;eval: v:oid = 0}
                        {x2;eval: v:qmid = 0}
                        {x2;tree:$sessionvars['examsessionsetting']['examsetting']['questypelite'],lite,qid}
                        {x2;if:v:lite}
                        {x2;eval: v:quest = v:key}
                        {x2;if:$sessionvars['examsessionquestion']['questions'][v:quest] || $sessionvars['examsessionquestion']['questionrows'][v:quest]}
                        {x2;if:$data['currentbasic']['basicexam']['changesequence']}
                        {x2;eval: shuffle($sessionvars['examsessionquestion']['questions'][v:quest]);}
                        {x2;eval: shuffle($sessionvars['examsessionquestion']['questionrows'][v:quest]);}
                        {x2;endif}
						{x2;eval: v:oid++}
						<h3 class="title">
							{x2;$ols[v:oid]}、{x2;$questype[v:quest]['questype']}
							<a class="badge pull-right resize"><em class="glyphicon glyphicon-resize-full"></em></a>
						</h3>
						<ul class="list-unstyled list-img">
							<li id="qt_{x2;v:quest}">
                                {x2;eval: v:tid = 0}
                                {x2;tree:$sessionvars['examsessionquestion']['questions'][v:quest],question,qnid}
                                {x2;eval: v:tid++}
                                {x2;eval: v:qmid++}
								<a id="sign_{x2;v:question['questionid']}" href="#q_{x2;v:question['questionid']}" class="btn btn-default qindex{x2;if:$sessionvars['examsessionsign'][v:question['questionid']]} btn-danger{x2;endif}">{x2;v:tid}</a>
                                {x2;endtree}
                                {x2;tree:$sessionvars['examsessionquestion']['questionrows'][v:quest],questionrow,qrid}
                                {x2;tree:v:questionrow['data'],question,did}
                                {x2;eval: v:tid++}
                                {x2;eval: v:qmid++}
								<a id="sign_{x2;v:question['questionid']}" href="#q_{x2;v:question['questionid']}" class="btn btn-default qindex{x2;if:$sessionvars['examsessionsign'][v:question['questionid']]} btn-danger{x2;endif}">{x2;v:tid}</a>
                                {x2;endtree}
                                {x2;endtree}
							</li>
						</ul>
                        {x2;endif}
                        {x2;endif}
                        {x2;endtree}
					</div>
				</div>
				<form class="col-xs-9 nopadding" id="paper" action="index.php?exam-app-exampaper-score">
                    {x2;eval: v:oid = 0}
                    {x2;eval: v:qcid = 0}
                    {x2;tree:$sessionvars['examsessionsetting']['examsetting']['questypelite'],lite,qid}
                    {x2;if:v:lite}
                    {x2;eval: v:quest = v:key}
                    {x2;if:$sessionvars['examsessionquestion']['questions'][v:quest] || $sessionvars['examsessionquestion']['questionrows'][v:quest]}
                    {x2;eval: v:oid++}
                    {x2;eval: v:tid = 0}
                    {x2;tree:$sessionvars['examsessionquestion']['questions'][v:quest],question,qnid}
                    {x2;eval: v:tid++}
                    {x2;eval: v:qcid++}
					<div class="content-box padding">
						<h2 class="title">
							<a id="q_{x2;v:question['questionid']}"></a>
							第 {x2;v:tid} 题 【 {x2;$questype[v:quest]['questype']}{x2;$sessionvars['examsessionsetting']['examsetting']['questype'][v:quest]['describe']} 】
							<a class="badge pull-right favor" data-questionid="{x2;v:question['questionid']}">收藏</a>
							<a class="badge pull-right" href="javascript:;" onclick="javascript:signQuestion('{x2;v:question['questionid']}',this,'{x2;$sessionvars['examsessionid']}');">{x2;if:$sessionvars['examsessionsign'][v:question['questionid']]}取消{x2;else}标记{x2;endif}</a>
							<input id="time_{x2;v:question['questionid']}" type="hidden" name="time[{x2;v:question['questionid']}]"/>
						</h2>
						<ul class="list-unstyled list-img">
							<li class="border morepadding">
								<div class="desc">
									<p>{x2;realhtml:v:question['question']}</p>
								</div>
							</li>
                            {x2;if:$questype[v:quest]['questsort']}
							<li class="border morepadding">
								{x2;eval: $data = v:question}
								{x2;include:plugin_editor}
							</li>
                            {x2;else}
							{x2;if:$questype[v:quest]['questchoice'] != 5}
							<li class="border morepadding">
								<div class="desc">
									<p>{x2;realhtml:v:question['questionselect']}</p>
								</div>
							</li>
							{x2;endif}
							<li class="border morepadding">
								<div class="nopadding desc">
                                    {x2;if:$questype[v:quest]['questchoice'] == 1 || $questype[v:quest]['questchoice'] == 4}
                                    {x2;tree:$selectorder,so,sid}
                                    {x2;if:v:key == v:question['questionselectnumber']}
                                    {x2;eval: break;}
                                    {x2;endif}
									<label class="inline"><input type="radio" name="question[{x2;v:question['questionid']}]" rel="{x2;v:question['questionid']}" value="{x2;v:so}" {x2;if:v:so == $sessionvars['examsessionuseranswer'][v:question['questionid']]}checked{x2;endif}/><span class="selector">{x2;v:so}</span> </label>
                                    {x2;endtree}
                                    {x2;elseif:$questype[v:quest]['questchoice'] == 5}
									<input type="text" name="question[{x2;v:question['questionid']}]" placeholder="点击此处填写答案" value="{x2;$sessionvars['examsessionuseranswer'][v:question['questionid']]}" rel="{x2;v:question['questionid']}"/>
                                    {x2;else}
                                    {x2;tree:$selectorder,so,sid}
                                    {x2;if:v:key >= v:question['questionselectnumber']}
                                    {x2;eval: break;}
                                    {x2;endif}
									<label class="inline"><input type="checkbox" name="question[{x2;v:question['questionid']}][{x2;v:key}]" rel="{x2;v:question['questionid']}" value="{x2;v:so}" {x2;if:in_array(v:so,(array)$sessionvars['examsessionuseranswer'][v:question['questionid']])}checked{x2;endif}/><span class="selector">{x2;v:so}</span> </label>
                                    {x2;endtree}
                                    {x2;endif}
								</div>
							</li>
                            {x2;endif}
						</ul>
					</div>
                    {x2;endtree}
                    {x2;tree:$sessionvars['examsessionquestion']['questionrows'][v:quest],questionrow,qnid}
                    {x2;tree:v:questionrow['data'],question,did}
                    {x2;eval: v:tid++}
                    {x2;eval: v:qcid++}
					<div class="content-box padding">
						<h2 class="title">
							<a id="q_{x2;v:question['questionid']}"></a>
							第 {x2;v:tid} 题 【 {x2;$questype[v:quest]['questype']}{x2;$sessionvars['examsessionsetting']['examsetting']['questype'][v:quest]['describe']} 】
							<a class="badge pull-right favor" data-questionid="{x2;v:question['questionid']}">收藏</a>
							<a class="badge pull-right" href="javascript:;" onclick="javascript:signQuestion('{x2;v:question['questionid']}',this,'{x2;$sessionvars['examsessionid']}');">{x2;if:$sessionvars['examsessionsign'][v:question['questionid']]}取消{x2;else}标记{x2;endif}</a>
							<input id="time_{x2;v:question['questionid']}" type="hidden" name="time[{x2;v:question['questionid']}]"/>
						</h2>
						<ul class="list-unstyled list-img">
							{x2;if:v:did == 1}
							<li class="border morepadding">
								<div class="desc">
									<p>{x2;realhtml:v:questionrow['qrquestion']}</p>
								</div>
							</li>
							{x2;endif}
							<li class="border morepadding">
								<div class="desc">
									<p>{x2;realhtml:v:question['question']}</p>
								</div>
							</li>
                            {x2;if:$questype[v:question['questiontype']]['questsort']}
							<li class="border morepadding">
								{x2;eval: $data = v:question}
								{x2;include:plugin_editor}
							</li>
                            {x2;else}
                            {x2;if:$questype[v:question['questiontype']]['questchoice'] != 5}
							<li class="border morepadding">
								<div class="desc">
									<p>{x2;realhtml:v:question['questionselect']}</p>
								</div>
							</li>
							{x2;endif}
							<li class="border morepadding">
								<div class="nopadding desc">
                                    {x2;if:$questype[v:question['questiontype']]['questchoice'] == 1 || $questype[v:question['questiontype']]['questchoice'] == 4}
                                    {x2;tree:$selectorder,so,sid}
                                    {x2;if:v:key == v:question['questionselectnumber']}
                                    {x2;eval: break;}
                                    {x2;endif}
									<label class="inline"><input type="radio" name="question[{x2;v:question['questionid']}]" rel="{x2;v:question['questionid']}" value="{x2;v:so}" {x2;if:v:so == $sessionvars['examsessionuseranswer'][v:question['questionid']]}checked{x2;endif}/><span class="selector">{x2;v:so}</span> </label>
                                    {x2;endtree}
                                    {x2;elseif:$questype[v:question['questiontype']]['questchoice'] == 5}
									<input type="text" name="question[{x2;v:question['questionid']}]" placeholder="点击此处填写答案" value="{x2;$sessionvars['examsessionuseranswer'][v:question['questionid']]}" rel="{x2;v:question['questionid']}"/>
                                    {x2;else}
                                    {x2;tree:$selectorder,so,sid}
                                    {x2;if:v:key >= v:question['questionselectnumber']}
                                    {x2;eval: break;}
                                    {x2;endif}
									<label class="inline"><input type="checkbox" name="question[{x2;v:question['questionid']}][{x2;v:key}]" rel="{x2;v:question['questionid']}" value="{x2;v:so}" {x2;if:in_array(v:so,$sessionvars['examsessionuseranswer'][v:question['questionid']])}checked{x2;endif}/><span class="selector">{x2;v:so}</span> </label>
                                    {x2;endtree}
                                    {x2;endif}
								</div>
							</li>
                            {x2;endif}
						</ul>
					</div>
                    {x2;endtree}
                    {x2;endtree}
                    {x2;endif}
                    {x2;endif}
                    {x2;endtree}
					<input type="hidden" name="insertscore" value="1"/>
					<input type="hidden" name="token" value="{x2;$token}"/>
					<input type="hidden" name="sessionid" value="{x2;$sessionvars['examsessionid']}"/>
				</form>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="submodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title" id="myModalLabel">交卷</h4>
			</div>
			<div class="modal-body">
				<p>共有试题 <span class="allquestionnumber">50</span> 题，已做 <span class="yesdonumber">0</span> 题。您确认要交卷吗？</p>
			</div>
			<div class="modal-footer">
				<button type="button" onclick="javascript:submitPaper();" class="btn btn-primary">确定交卷</button>
				<button aria-hidden="true" class="btn" type="button" data-dismiss="modal">再检查一下</button>
			</div>
		</div>
	</div>
</div>
<button style="display: none" hidden="hidden" id="launch-modal" type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">
	Launch modal
</button>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="myModalLabel">开始考试</h4>
			</div>
			<div class="modal-body">
				考试即将开始，点击确认按钮进入全屏考试
			</div>
			<div class="modal-footer">
				<button id="fullscreenBtn" type="button" data-dismiss="modal" class="btn btn-primary">确认</button>
			</div>
		</div>
	</div>
</div>
<button style="display: none" hidden="hidden" id="launch-modal1" type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal1">
	Launch modal
</button>
<div class="modal fade" id="myModal1" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="myModalLabel">警告</h4>
			</div>
			<div class="modal-body">
				本次考试需要在全屏状态下进行
			</div>
			<div class="modal-footer">
				<button id="fullscreenBtn1" onclick="openModal()" type="button" data-dismiss="modal" class="btn btn-primary">确认</button>
			</div>
		</div>
	</div>
</div>
<script>
    $(function(){
        $.get('index.php?exam-app-index-ajax-lefttime&sessionid={x2;$sessionvars['examsessionid']}&rand'+Math.random(),function(data){
            var setting = {
                time:{x2;eval: echo intval($sessionvars['examsessiontime'])},
                hbox:$("#timer_h"),
                mbox:$("#timer_m"),
                sbox:$("#timer_s"),
                finish:function(){
					alert("答题时间已结束")
                    submitPaper();
                }
            }
            setting.lefttime = parseInt(data);
			clock = new countdown(setting);
        });
        setInterval(saveanswer,120000);
    });

	document.getElementById('fullscreenBtn').addEventListener('click', function() {
		if (document.documentElement.requestFullscreen) {
			document.documentElement.requestFullscreen();
		} else if (document.documentElement.mozRequestFullScreen) { // Firefox
			document.documentElement.mozRequestFullScreen();
		} else if (document.documentElement.webkitRequestFullscreen) { // Chrome, Safari and Opera
			document.documentElement.webkitRequestFullscreen();
		} else if (document.documentElement.msRequestFullscreen) { // IE/Edge
			document.documentElement.msRequestFullscreen();
		}
	});

	document.addEventListener('fullscreenchange', function() {
		if (!document.fullscreenElement) {
			// alert('本次考试需要在全屏状态下进行');
			document.getElementById('launch-modal1').click()
		}
	});

	function openModal() {
		document.getElementById('launch-modal').click()
	}

	document.getElementById('launch-modal').click()
</script>
{x2;include:paper_footer}
</body>
</html>