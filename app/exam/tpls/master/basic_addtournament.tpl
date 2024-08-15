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
							<li><a href="index.php?{x2;$_app}-master-basic-tournament">赛事列表</a></li>
							<li class="active">添加赛事</li>
						</ol>
					</div>
				</div>
				<div class="box itembox" style="padding-top:10px;margin-bottom:0px;">
					<h4 class="title" style="padding:10px;">
						添加赛事
						<a class="btn btn-primary pull-right" href="index.php?exam-master-basic-tournament">赛事列表</a>
					</h4>
					<form action="index.php?exam-master-basic-addtournament" method="post" class="form-horizontal">
						<fieldset>
						<div class="form-group">
							<label for="basic" class="control-label col-sm-2">赛事名称</label>
							<div class="col-sm-8">
								<input class="form-control" id="basic" name="args[name]" type="text" placeholder="请输入赛事名称" needle="needle" msg="您必须输入赛事名称" />
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-sm-2">赛事类型</label>
							<div class="col-sm-9">
								<label class="radio-inline">
									<input name="args[type]" type="radio" value="1" checked />大赛
								</label>
								<label class="radio-inline">
									<input name="args[type]" type="radio" value="2" />考级
								</label>
							</div>
						</div>
						<div class="form-group">
							<label for="basicthumb" class="control-label col-sm-2">赛事缩略图</label>
							<div class="col-sm-9">
								<script type="text/template" id="pe-template-basicthumb">
						    		<div class="qq-uploader-selector" style="width:30%" qq-drop-area-text="可将图片拖拽至此处上传" style="clear:both;">
						            	<div class="qq-upload-button-selector" style="clear:both;">
						                	<ul class="qq-upload-list-selector list-unstyled" aria-live="polite" aria-relevant="additions removals" style="clear:both;">
								                <li class="text-center">
								                    <div class="thumbnail">
														<img class="qq-thumbnail-selector" alt="点击上传新图片">
														<input type="hidden" class="qq-edit-filename-selector" name="args[thumb]" tabindex="0">
													</div>
								                </li>
								            </ul>
								            <ul class="qq-upload-list-selector list-unstyled" aria-live="polite" aria-relevant="additions removals" style="clear:both;">
									            <li class="text-center">
									                <div class="thumbnail">
														<img class="qq-thumbnail-selector" src="/files/public/img/noimage.gif" alt="点击上传新图片2">
														<input type="hidden" class="qq-edit-filename-selector" name="args[thumb]" tabindex="0" value="/files/public/img/noimage.gif">
						                			</div>
									            </li>
									        </ul>
						                </div>
						            </div>
						        </script>
						        <div class="fineuploader" attr-type="thumb" attr-template="pe-template-basicthumb"></div>
							</div>
						</div>
						<div class="form-group">
							<label for="basicapi" class="control-label col-sm-2">报考时间</label>
							<div class="col-sm-8">
								<input class="form-control datetimepicker" placeholder="请输入报考时间" data-minview="0" data-date="{x2;date:TIME,'Y-m-d H:i:s'}" data-date-format="yyyy-mm-dd hh:ii:ss" type="text" id="signup_time" name="args[signup_time]" needle="needle" msg="您必须输入报考时间">
							</div>
						</div>
						<div class="form-group">
							<label for="basicapi" class="control-label col-sm-2">报考网址</label>
							<div class="col-sm-8">
								<input class="form-control" id="basic" name="args[signup_url]" type="text" placeholder="请输入报考网址" needle="needle" msg="您必须输入报考网址" />
							</div>
						</div>
						<div class="form-group">
							<label for="basicapi" class="control-label col-sm-2">赛事介绍</label>
							<div class="col-sm-8">
								<textarea id="contenttext" rows="7" cols="4" class="ckeditor" name="args[content]"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="basic" class="control-label col-sm-2"></label>
							<div class="col-sm-9">
								<button class="btn btn-primary" type="submit">提交</button>
								<input type="hidden" name="page" value="{x2;$page}"/>
								<input type="hidden" name="inserttournament" value="1"/>
								{x2;tree:$search,arg,aid}
								<input type="hidden" name="search[{x2;v:key}]" value="{x2;v:arg}"/>
								{x2;endtree}
							</div>
						</div>
						</fieldset>
					</form>
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