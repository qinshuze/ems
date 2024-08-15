{x2;include:header}
<style>
	.tag {
		font-size: 14px;
	}
	img {
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
					<div class="content-box">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								{x2;tree:$banners['data'],content,cid}
								<div class="swiper-slide">
									<a href="index.php?content-app-content&contentid={x2;v:content['contentid']}">
										<img height="500" width="100%" src="{x2;v:content['contentthumb']}" style="max-width:100%;"/>
									</a>
								</div>
								{x2;endif}
							</div>
							<div class="swiper-pagination"></div>
						</div>
					</div>
					<div class="content-box padding">
						<h2 class="title">
							大赛
							<a href="index.php?exam" class="badge pull-right">更多 <em class="glyphicon glyphicon-plus"></em> </a>
						</h2>
						<ul class="list-box list-unstyled">
							{x2;tree:$tournaments1,tournament,bid}
							<li class="col-xs-4 box">
								<a href="index.php?exam-app-basics-detail_list&tournament_id={x2;v:tournament['id']}">
									<div class="img">
										<img height="200" src="{x2;if:v:tournament['thumb']}{x2;v:tournament['thumb']}{x2;else}app/core/styles/img/item.jpg{x2;endif}" />
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
							{x2;if:v:bid == 3}
						</ul>
						<ul class="list-box list-unstyled">
							{x2;endif}
							{x2;endtree}
						</ul>
					</div>
					<div class="content-box padding">
						<h2 class="title">
							考级
							<a href="index.php?exam" class="badge pull-right">更多 <em class="glyphicon glyphicon-plus"></em> </a>
						</h2>
						<ul class="list-box list-unstyled">
							{x2;tree:$tournaments2,tournament,bid}
							<li class="col-xs-4 box">
								<a href="index.php?exam-app-basics-detail_list&tournament_id={x2;v:tournament['id']}">
									<div class="img">
										<img height="200" src="{x2;if:v:tournament['thumb']}{x2;v:tournament['thumb']}{x2;else}app/core/styles/img/item.jpg{x2;endif}" />
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
							{x2;if:v:bid == 3}
						</ul>
						<ul class="list-box list-unstyled">
							{x2;endif}
							{x2;endtree}
						</ul>
					</div>
					<div class="content-box padding">
						<h2 class="title">
							最新课程
							<a href="index.php?course" class="badge pull-right">更多 <em class="glyphicon glyphicon-plus"></em> </a>
						</h2>
						<ul class="list-unstyled list-box">
							{x2;tree:$courses['data'],content,cid}
							<li class="col-xs-4 box">
								<a href="index.php?course-app-course&csid={x2;v:content['csid']}">
									<div class="img">
										<img src="{x2;if:v:content['csthumb']}{x2;v:content['csthumb']}{x2;else}app/core/styles/img/item.jpg{x2;endif}" />
									</div>
									<h5 class="box-title">{x2;v:content['cstitle']}</h5>
									<div class="intro">
										<p>{x2;substring:v:content['csdescribe'],78}</p>
									</div>
								</a>
							</li>
							{x2;if:v:cid == 3}
						</ul>
						<ul class="list-box list-unstyled">
							{x2;endif}
							{x2;endtree}
						</ul>
					</div>
					<div class="content-box padding">
						<h2 class="title">
							热点新闻
							<a href="index.php?content" class="badge pull-right">更多 <em class="glyphicon glyphicon-plus"></em> </a>
						</h2>
						<ul class="list-unstyled list-img">
							{x2;tree:$topnews['data'],content,cid}
							<li class="border morepadding">
								<h4 class="shorttitle">
									<a href="index.php?content-app-content&contentid={x2;v:content['pccontentid']}">{x2;v:content['pctitle']}</a>
								</h4>
								<div class="intro">
									<div class="col-xs-3 img">
										<img src="{x2;v:content['pcthumb']}" />
									</div>
									<div class="desc">
										<p>{x2;v:content['pcdescribe']}</p>
										<p class="toolbar">
											{x2;date:v:content['pctime'],'Y-m-d'}
											<a href="index.php?content-app-content&contentid={x2;v:content['pccontentid']}" class="hide btn btn-info pull-right more">查看详情</a>
										</p>
									</div>
								</div>
							</li>
							{x2;endtree}
						</ul>
					</div>
				</div>
				<div class="col-xs-3 nopadding">
					<div class="content-box padding">
						<h2 class="title">网站公告</h2>
						<ul class="list-unstyled list-txt">
							{x2;tree:$notices['data'],content,lid}
							<li class="border">
								<a target="_blank" href="index.php?content-app-content&contentid={x2;v:content['contentid']}">
									{x2;substring:v:content['contenttitle'],45}
								</a>
							</li>
							{x2;endtree}
						</ul>
					</div>
					<div class="content-box padding">
						<h2 class="title">友情链接</h2>
						<ul class="list-unstyled list-txt">
							{x2;tree:$links['data'],content,lid}
							<li class="border">
								<a target="_blank" href="index.php?content-app-content&contentid={x2;v:content['contentid']}">
									{x2;substring:v:content['contenttitle'],45}
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
<script>
	$(function(){
		var mySwiper = new Swiper ('.swiper-container',{
			autoplay: true,
			loop:true,
			pagination: {
				el: '.swiper-pagination'
			}
		});
	});
</script>
</body>
</html>