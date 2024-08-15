{x2;if:!$userhash}
{x2;include:header}
<body>
{x2;include:nav}
<div class="container-fluid">
	<div class="row-fluid">
		<div class="main">
			<div class="col-xs-2 leftmenu">
				{x2;include:menu}
			</div>
			<div id="datacontent">
{x2;endif}
				<div class="box itembox" style="margin-bottom:0px;border-bottom:1px solid #CCCCCC;">
					<div class="col-xs-12">
						<ol class="breadcrumb">
							<li><a href="index.php?{x2;$_app}-master">{x2;$apps[$_app]['appname']}</a></li>
							<li class="active">赛事列表</li>
						</ol>
					</div>
				</div>
				<div class="box itembox" style="padding-top:10px;margin-bottom:0px;">
					<h4 class="title" style="padding:10px;">
						赛事列表
						<a class="btn btn-primary pull-right" href="index.php?exam-master-basic-addtournament">添加赛事</a>
					</h4>
					<form action="index.php?exam-master-basic-tournament" method="post">
						<table class="table form-inline">
							<thead>
				                <tr>
							        <th colspan="2">搜索</th>
							        <th></th>
							        <th></th>
							        <th></th>
							        <th></th>
				                </tr>
				            </thead>
							<tr>
								<td>
									关键字：
								</td>
								<td>
									<input class="form-control" name="search[keyword]" type="text" value="{x2;$search['keyword']}"/>
								</td>
								<td>
									类型：
								</td>
								<td>
									<select name="search[type]" class="form-control">
										<option value="0">不限</option>
										<option value="1"{x2;if:1 == $search['type']} selected{x2;endif}>大赛</option>
										<option value="2"{x2;if:-1 == $search['type']} selected{x2;endif}>考级</option>
									</select>
								</td>
								<td>
									<button class="btn btn-primary" type="submit">提交</button>
								</td>
					        </tr>
						</table>
						<div class="input">
							<input type="hidden" value="1" name="search[argsmodel]" />
						</div>
					</form>
			        <form action="index.php?exam-master-basic-deltournament" method="post">
				        <table class="table table-hover table-bordered">
							<thead>
								<tr class="info">
				                    <th width="60"><input type="checkbox" class="checkall"/></th>
				                    <th width="80">赛事ID</th>
							        <th>缩略图</th>
							        <th width="220">赛事名称</th>
							        <th width="220">报考时间</th>
							        <th width="80">报考网址</th>
							        <th width="60">类型</th>
							        <th width="260">操作</th>
				                </tr>
				            </thead>
				            <tbody>
				                {x2;tree:$tournaments['data'],tournament,bid}
						        <tr>
									<td>
										<input type="checkbox" name="ids[]" value="{x2;v:tournament['id']}"/>
									</td>
									<td>
										{x2;v:tournament['id']}
									</td>
									<td class="picture">
										<img style="width:48px;" src="{x2;v:tournament['thumb']}" alt="">
									</td>
									<td>
										{x2;v:tournament['name']}
									</td>
									<td>
										<?php echo date('Y-m-d', $tournament['signup_time']); ?>
									</td>
									<td class="text-truncate" title="{x2;v:tournament['signup_url']}">
										{x2;v:tournament['signup_url']}
									</td>
									<td>
										{x2;$cnTypes[v:tournament['type']]}
									</td>
									<td>
										<a role="button" class="btn btn-primary btn-xs" href="index.php?exam-master-basic-modifytournament&page={x2;$page}&id={x2;v:tournament['id']}{x2;$u}" title="修改">修改</a>
										<a role="button" class="btn btn-danger btn-xs confirm" href="index.php?exam-master-basic-deltournament&ids[]={x2;v:tournament['id']}&page={x2;$page}{x2;$u}" title="删除">删除</a>
									</td>
						        </tr>
						        {x2;endtree}
				        	</tbody>
				        </table>
				        <div class="form-group">
				            <div class="col-sm-9">
				            	<button class="btn btn-primary" type="submit">删除</button>
				            </div>
						</div>
					</form>
			        <ul class="pagination pull-right">
						{x2;$tournaments['pages']}
			        </ul>
				</div>
			</div>
{x2;if:!$userhash}
		</div>
	</div>
</div>
{x2;include:footer}
</body>
</html>
{x2;endif}