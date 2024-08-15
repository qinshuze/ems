{x2;include:header}
<style>
	.img img {
		height: 200px;
		object-fit: cover;
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
							<h2 class="title">大赛</h2>
							<ul class="list-box list-unstyled">
								{x2;tree:$tournaments1['data'],tournament,bid}
								<li class="col-xs-4 box">
									<a href="index.php?{x2;$_app}-app-basics-detail_list&tournament_id={x2;v:tournament['id']}">
										<div class="img">
											<img src="{x2;if:v:tournament['thumb']}{x2;v:tournament['thumb']}{x2;else}app/core/styles/img/item.jpg{x2;endif}" />
										</div>
										<h5 class="box-title">{x2;v:tournament['name']}</h5>
										<!--<div class="intro">
											<p>{x2;substring:v:tournament['content'],78}</p>
										</div>-->
									</a>
									<div style="margin-top: 30px">
										<p class="tag">报名时间：<a><?php echo date('Y-m-d h:i:s', $tournament['signup_time']); ?></a></p>
										<p style="width: 100%" class="tag d-inline-block text-truncate">报名地址：<a title="{x2;v:tournament['signup_url']}">{x2;v:tournament['signup_url']}</a></p>
									</div>
								</li>
								{x2;if:v:bid < count($tournaments1['data']) && v:bid % 3 == 0}
							</ul>
							<ul class="list-box list-unstyled">
								{x2;endif}
								{x2;endtree}
							</ul>
							{x2;if:$tournaments1['pages']}
							<ul class="list-img">
								<li class="border padding">
									<ul class="pagination pull-right">
										{x2;$tournaments1['pages']}
									</ul>
								</li>
							</ul>
							{x2;endif}
						</div>
						<div class="content-box padding">
							<h2 class="title">考级</h2>
							<ul class="list-box list-unstyled">
								{x2;tree:$tournaments2['data'],tournament,bid}
								<li class="col-xs-4 box">
									<a href="index.php?{x2;$_app}-app-basics-detail_list&tournament_id={x2;v:tournament['id']}">
										<div class="img">
											<img src="{x2;if:v:tournament['thumb']}{x2;v:tournament['thumb']}{x2;else}app/core/styles/img/item.jpg{x2;endif}" />
										</div>
										<h5 class="box-title">{x2;v:tournament['name']}</h5>
										<!--<div class="intro">
											<p>{x2;substring:v:tournament['content'],78}</p>
										</div>-->
									</a>
									<div style="margin-top: 30px">
										<p class="tag">报名时间：<a><?php echo date('Y-m-d h:i:s', $tournament['signup_time']); ?></a></p>
										<p style="width: 100%" class="tag d-inline-block text-truncate">报名地址：<a title="{x2;v:tournament['signup_url']}">{x2;v:tournament['signup_url']}</a></p>
									</div>
								</li>
								{x2;if:v:bid < count($tournaments2['data']) && v:bid % 3 == 0}
							</ul>
							<ul class="list-box list-unstyled">
								{x2;endif}
								{x2;endtree}
							</ul>
							{x2;if:$tournaments2['pages']}
							<ul class="list-img">
								<li class="border padding">
									<ul class="pagination pull-right">
										{x2;$tournaments2['pages']}
									</ul>
								</li>
							</ul>
							{x2;endif}
						</div>
					</div>
					<div class="col-xs-3 nopadding">
						<div class="content-box padding">
							<form action="index.php" method="get" class="dxform">
								<input class="form-control pull-left" type="text" name="search[keyword]" placeholder="考场关键词" style="width: 75%;height: 40px;" value="{x2;$search['keyword']}" />
								<button class="btn btn-primary pull-left" type="submit" style="width:25%;">搜索</button>
								<input type="hidden" name="route" value="exam-app">
							</form>
						</div>
						<div class="content-box padding">
							<h2 class="title">最新考场</h2>
							<ul class="list-unstyled list-img">
                                {x2;tree:$news,basic,bid}
								<li class="border padding">
									<a href="index.php?{x2;$_app}-app-index-setCurrentBasic&basicid={x2;v:basic['basicid']}" class="ajax">
										<div class="intro">
											<div class="col-xs-5 img noleftpadding">
												<img style="height: 66px" src="{x2;if:v:basic['basicthumb']}{x2;v:basic['basicthumb']}{x2;else}app/core/styles/img/item.jpg{x2;endif}" />
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
</body>
</html>