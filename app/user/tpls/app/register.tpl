{x2;include:header}
<body>
<div class="container-fluid" style="height: 100vh;background:radial-gradient(circle at 50% 30%, #4f4f4f, #000);">
	<div class="row-fluid">
		<div class="pages">
			<div class="content" style="margin-top: 10vh;">
				<div class="col-xs-3 padding"></div>
				<div class="col-xs-6 nopadding">
					<div class="content-box padding">
						<h2 class="title">
							用户注册
							<a href="index.php" class="badge pull-right">首页</a>
						</h2>
						<form method="post" action="index.php?user-app-register">
							<fieldset class="logbox">
								<div class="form-group underline">
									<label class="block">
										<div class="col-xs-4 tip">
											用户名
										</div>
										<div class="col-xs-8">
											<input class="noborder" name="args[username]" datatype="userName" needle="needle" msg="请您输入正确的用户名" placeholder="请输入用户名">
										</div>
									</label>
								</div>
								<div class="form-group underline">
									<label class="block">
										<div class="col-xs-4 tip">
											邮箱
										</div>
										<div class="col-xs-8">
											<input class="noborder" name="args[useremail]" id="email" datatype="email" needle="needle" msg="请你输入邮箱" placeholder="请输入邮箱">
										</div>
									</label>
								</div>
								<div class="form-group underline">
									<label class="block">
										<div class="col-xs-4 tip">
											密码
										</div>
										<div class="col-xs-8">
											<input class="noborder" name="args[userpassword]" datatype="password" needle="needle" msg="请您输入正确的密码" placeholder="请输入密码">
										</div>
									</label>
								</div>
								<div class="form-group underline">
									<label class="block">
										<div class="col-xs-4 tip">
											手机号
										</div>
										<div class="col-xs-8">
											<input class="noborder" name="args[userphone]" datatype="phone" needle="needle" msg="请您输入正确的手机号" placeholder="请输入手机号">
										</div>
									</label>
								</div>
								<!--<div class="form-group underline">
									<label class="block">
										<div class="col-xs-4 tip">
											密保
										</div>
										<div class="col-xs-8">
											<input class="noborder" name="args[confidentiality_title]" datatype="phone" needle="needle" msg="请您输入密保问题" placeholder="请输入密保问题">
											<input class="noborder" name="args[confidentiality_answer]" datatype="phone" needle="needle" msg="请您输入密保答案" placeholder="请输入密保答案">
										</div>
									</label>
								</div>-->
								<div class="form-group underline">
									<label class="block">
										<div class="col-xs-4 tip">
											注册类型
										</div>
										<div class="col-xs-8">
											<label style="font-weight: 400;margin-right: 15px;font-size: 14px">
												<input checked style="margin: 0;" type="radio" name="args[is_mechanism]" id="is_mechanism0" value="0"> 普通用户
											</label>
											<label style="font-weight: 400;font-size: 14px">
												<input style="margin: 0;" type="radio" name="args[is_mechanism]" id="is_mechanism1" value="1"> 机构用户
											</label>
										</div>
									</label>
								</div>
								<div id="mechanism_name" style="display: none" class="form-group underline">
									<label class="block">
										<div class="col-xs-4 tip">
											机构名称
										</div>
										<div class="col-xs-8">
											<input class="noborder" name="args[mechanism]" msg="请您输入正确的机构名称" placeholder="请输入机构名称">
										</div>
									</label>
								</div>
                                {x2;if:$app['appsetting']['emailverify']}
								<div class="form-group underline">
									<label class="block">
										<div class="col-xs-4 tip">
											验证码
										</div>
										<div class="col-xs-6">
											<input class="noborder" name="randcode" needle="needle" msg="请您输入正确的验证码" placeholder="请输入验证码">
										</div>
										<div class="col-xs-2">
											<button type="button" class="btn btn-danger pull-right" id="sendphonecode">发送验证码</button>
										</div>
									</label>
								</div>
                                {x2;endif}
								<div class="form-group">
									<div class="col-xs-12 text-center">
										<label class="inline"><input type="radio" name="agreement"><span class="selector">同意《隐私与注册协议》</span></label>
									</div>
								</div>
								<div class="form-group text-center">
                                    {x2;if:$app['appsetting']['closeregist']}
									<button type="button" class="btn btn-primary login">管理员禁止注册</button>
                                    {x2;else}
									<button class="btn btn-primary login">注册</button>
                                    {x2;endif}
									<a href="index.php?user-app-login" class="btn btn-default login">登陆</a>
									<input type="hidden" value="1" name="userregister"/>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
				<div class="col-xs-3 padding"></div>
			</div>
		</div>
	</div>
</div>
<div id="modal" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button aria-hidden="true" class="close" type="button" data-dismiss="modal">×</button>
				<h4 id="myModalLabel">
					隐私与注册协议
				</h4>
			</div>
			<div class="modal-body" id="modal-body" style="height: 360px;overflow:hidden;overflow-y: auto">{x2;block:1}</div>
			<div class="modal-footer">
				<button aria-hidden="true" class="btn btn-primary" data-dismiss="modal">同意并继续</button>
			</div>
		</div>
	</div>
</div>
<script>
	var eMechanism = document.getElementById('mechanism_name')
	document.getElementById('is_mechanism0').onclick = function () {
		eMechanism.style.display = 'none'
		eMechanism.querySelector('input').removeAttribute('needle')
	}

	document.getElementById('is_mechanism1').onclick = function () {
		eMechanism.style.display = 'block'
		eMechanism.querySelector('input').setAttribute('needle', 'needle')
	}

	$(function(){
		$('#modal').modal();
		{x2;if:$app['appsetting']['emailverify']}
		var sendstatus = true;
		$('#sendphonecode').click(function(){
			var _this = $(this);
			if(sendstatus)
			{
				$.getJSON('index.php?core-api-index-sendmail&action=reg&email='+$('#email').val()+'&userhash='+Math.random(),function(data){
					if(parseInt(data.statusCode) == 200)
					{
						_this.html('120秒重发');
						sendstatus = false;
						sendtime = 120;
						sendevent = setInterval(function(){
							if(sendtime > 0)
							{
								sendtime--;
								_this.html(sendtime+'秒重发');
							}
							else
							{
								sendstatus = true;
								_this.html('发送验证码');
								clearInterval(sendevent);
							}
						},1000);
					}
					else
					{
						$.zoombox.show('ajax',data);
					}
				});
			}
		});
		{x2;endif}
	})
</script>
</body>
</html>