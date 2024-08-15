{x2;include:header}

<style>
	.title-tag {
		padding: 10px 10px;
		display: inline-block;
		cursor: pointer;
		border-bottom: 2px solid transparent;
	}
	.title-tag.active {
		border-bottom: 2px solid #337ab7;
	}

	html body .pages .content .content-box .title:after {
		background-color: #337ab7;
	}
	img {
		object-fit: cover;
		flex: 1;
	}
</style>

<body>

<div class="container-fluid">
	<div class="row-fluid">
		<div class="pages">
            {x2;include:nav}
			<div class="content">
				<div class="col-xs-9">
					<div class="content-box padding">
						<div style="border-bottom: 1px solid #f0f0f0;">
							<div class="title-tag active" data-target="basic-container">
								<span>开通考场</span>
							</div>
							<div class="title-tag" data-target="tournament-container">
								<span>赛事介绍</span>
							</div>
						</div>
						<ul id="basic-container" class="tags-container list-img list-unstyled">
							{x2;tree:$basics,basic,bid}
							<li class="border morepadding">
								<h4 class="shorttitle">{x2;v:basic['basic']}</h4>
								<div class="intro">
									<div class="col-xs-3 img">
										<img height="120" src="{x2;if:v:basic['basicthumb']}{x2;v:basic['basicthumb']}{x2;else}app/exam/styles/image/paper.png{x2;endif}" />
									</div>
									<div class="desc">
										<p>{x2;v:basic['basicdescribe']}</p>
										<p class="toolbar">
											<a class="badge">当前积分：{x2;$_user['usercoin']}</a>
											<a class="badge" href="index.php?user-app-payfor">在线充值</a>

											{x2;if:v:basic['basicexam']['model'] == 0}
											<a class="badge">练习/考试</a>
											{x2;endif}

											{x2;if:v:basic['basicexam']['model'] == 1}
											<a class="badge">练习</a>
											{x2;endif}

											{x2;if:v:basic['basicexam']['model'] == 2}
											<a class="badge">考试</a>
											{x2;endif}

											<a class="badge" href="#myModal" role="button" data-toggle="modal">代金券充值</a>
										</p>
										<div class="toolbar">
                                            {x2;if:$isopen[v:basic['basicid']]}

											{x2;if:v:basic['basicexam']['model'] == 0}
											<a class="btn btn-info pull-right more ajax" href="index.php?exam-app-index-setCurrentBasic&basicid={x2;v:basic['basicid']}">进入考场</a>
											{x2;endif}

											{x2;if:v:basic['basicexam']['model'] == 1}
											<a class="btn btn-info pull-right more ajax" href="index.php?exam-app-index-setCurrentBasic&basicid={x2;v:basic['basicid']}">进入训练场</a>
											{x2;endif}

											{x2;if:v:basic['basicexam']['model'] == 2}
											<a class="btn btn-info pull-right more ajax" href="index.php?exam-app-index-setCurrentBasic&basicid={x2;v:basic['basicid']}">进入考场</a>
											{x2;endif}

											{x2;else}
											{x2;if:$allowopen[v:basic['basicid']]}
											{x2;if:v:basic['basicdemo']}
											<a class="btn btn-info pull-right more confirm" msg="确定要开通吗？" href="index.php?exam-app-basics-openit&basicid={x2;v:basic['basicid']}">免费开通</a>
											{x2;else}
											{x2;if:$price[v:basic['basicid']]}
											选择要开通的时长
											<div class="more">
												{x2;tree:$price[v:basic['basicid']],p,pid}
												<a class="btn btn-primary confirm" msg="确定要开通吗？" href="index.php?exam-app-basics-openit&basicid={x2;v:basic['basicid']}&opentype={x2;v:key}">{x2;v:p['price']}积分兑换{x2;v:p['time']}天</a>
												{x2;endtree}
											</div>
												{x2;else}
												<a class="btn btn-default pull-right more" href="javascript:;">请管理员设置考场价格</a>
												{x2;endif}
											{x2;endif}
											{x2;else}
											<a class="btn btn-default pull-right more" href="javascript:;">您所在的用户组不能开通本考场</a>
											{x2;endif}
                                            {x2;endif}
										</div>
									</div>
								</div>
							</li>
							{x2;endtree}
						</ul>
						<div style="padding: 20px;" hidden="hidden" class="tags-container" id="tournament-container">
							{x2;realhtml:$tournament['content']}
						</div>
					</div>
				</div>
				<div class="col-xs-3 nopadding">
					<div class="content-box padding">
						<h2 class="title">最新考场<a href="index.php?exam-app-basics-open" class="badge pull-right">更多 <em class="glyphicon glyphicon-plus"></em> </a> </h2>
						<ul class="list-unstyled list-img">
                            {x2;tree:$news,basic,bid}
							<li class="border padding">
								<a href="index.php?{x2;$_app}-app-index-setCurrentBasic&basicid={x2;v:basic['basicid']}" class="ajax">
									<div class="intro">
										<div class="col-xs-5 img noleftpadding">
											<img src="{x2;if:v:basic['basicthumb']}{x2;v:basic['basicthumb']}{x2;else}app/core/styles/img/item.jpg{x2;endif}" />
										</div>
										<div class="desc">
											<p>{x2;v:basic['basic']}</p>
										</div>
									</div>
								</a>
							</li>
                            {x2;endtree}
						</ul>
					</div>
				</div>
			</div>
            {x2;include:footer}
		</div>
	</div>
</div>
<form aria-hidden="true" id="myModal" method="post" class="modal fade" role="dialog" aria-labelledby="#myModalLabel" action="index.php?exam-app-basics-coupon">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button aria-hidden="true" class="close" type="button" data-dismiss="modal">×</button>
				<h4 class="modal-title" id="myModalLabel">代金券充值</h4>
			</div>
			<div class="modal-body" id="modal-body">
				<div class="control-group">
					<div class="controls">
						<input placeholder="请输入16位代金券号码" type="text" class="form-control" name="couponsn" value="" needle="needle" msg="请输入16位代金券号码"/>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<input name="coupon" type="hidden" value="1">
				<button class="btn btn-primary" type="submit">充值</button>
			</div>
		</div>
	</div>
</form>

<script>
	var elTitleTag = document.querySelectorAll('.title-tag')

	elTitleTag.forEach(function (el) {
		el.onclick = function (ev) {
			elTitleTag.forEach(function (element) {
				var className = element.getAttribute('class')
				element.setAttribute('class', className.replace('active', ''))
			})

			var className = el.getAttribute('class').trim()
			el.setAttribute('class', className + ' active')

			document.querySelectorAll('.tags-container').forEach(function (element) {
				element.hidden = true
			})

			document.getElementById(el.dataset.target).hidden = false
		}
	})

</script>
</body>
</html>