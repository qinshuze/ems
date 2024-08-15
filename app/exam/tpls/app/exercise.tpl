{x2;include:header}
<style>
	.badge.active {
		background-color: #0f74a8;
	}
</style>
<body>
<div class="container-fluid">
	<div class="row-fluid">
		<div class="pages">
            {x2;include:examnav}
			<div class="content">
				<div class="col-xs-3" style="width: 20%">
					<div class="content-box padding">
                        {x2;include:menu}
					</div>
				</div>
				<div class="col-xs-9 nopadding" style="width: 80%">
                    <div class="content-box padding">
						<h2 class="title">强化训练</h2>
						<form action="index.php?exam-app-exercise" method="post" action-before="clearStorage">
							<fieldset class="logbox">
								<div class="form-group underline">
									{x2;tree:$knows,know,sid}
									{x2;if:v:sid < 10}
									<a data-knowid="{x2;v:know['knowsid']}" data-sectionid="{x2;v:know['sectionid']}" class="know badge">{x2;v:know['knows']}</a>
									{x2;endif}
									{x2;endtree}
								</div>
								<div class="form-group underline">
									<label class="block">
										<div class="col-xs-4 tip">
											章节选择
										</div>
										<div class="col-xs-8 form-inline">
											<select autocomplete="off" id="thesectionid" name="args[sectionid]" class="combox form-control" target="theknowsid" refUrl="index.php?exam-app-index-ajax-getknowsbysectionid&sectionid={value}" more="questionnumbers">
												<option value="0">请选择章节</option>
												{x2;tree:$data['currentbasic']['basicknows'],section,sid}
												<option value="{x2;v:key}">{x2;$sections[v:key]['section']}</option>
												{x2;endtree}
											</select>
											<select autocomplete="off" name="args[knowsid]" id="theknowsid" class="combox form-control" target="questionnumbers" refUrl="index.php?exam-app-exercise-ajax-getQuestionNumber&knowsid={value}">
												<option value="0">请选择知识点</option>
											</select>
										</div>
									</label>
								</div>
								<div class="form-group underline">
									<label class="block">
										<div class="col-xs-4 tip">
											试卷名称
										</div>
										<div class="col-xs-8 form-inline">
											<input placeholder="填写试卷名称" type="text" name="args[title]" class="form-control" needle="needle" msg="请输入试卷名称"/>
										</div>
									</label>
								</div>
								<div class="form-group underline">
									<label class="block">
										<div class="col-xs-4 tip">
											做题时间
										</div>
										<div class="col-xs-8 form-inline">
											<input type="text" name="args[time]" class="form-control text-center" datatype="number" min="1" needle="needle" msg="请输入做题时间" size="2" value='60'/> 分钟
										</div>
									</label>
								</div>
								<div id="questionnumbers"></div>
								<div class="form-group  text-center">
									<button type="submit" class="btn btn-primary">开始测试</button>
									<input type="hidden" name="setExecriseConfig" value="1" />
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
            {x2;include:footer}
		</div>
	</div>
</div>
<script>
	var elKnows = document.querySelectorAll('.know')
	var slSection = document.getElementById('thesectionid')
	var slKnow = document.getElementById('theknowsid')

	function activeKnowTag(el) {
		elKnows.forEach(function (element) {
			var className = element.getAttribute('class')
			element.setAttribute('class', className.replace('active', ''))
		})

		var className = el.getAttribute('class').trim()
		el.setAttribute('class', className + ' active')
	}

	elKnows.forEach(function (el) {
		el.onclick = function (ev) {
			activeKnowTag(el)

			var sectionId = el.dataset.sectionid
			var knowId = el.dataset.knowid

			slSection.value = sectionId
			slSection.dispatchEvent(new Event('change', {
				bubbles: true, cancelable: true
			}))


			setTimeout(function () {
				slKnow.value = knowId
				slKnow.dispatchEvent(new Event('change', {
					bubbles: true, cancelable: true
				}))
			}, 200)
		}
	})

	slKnow.addEventListener('change', function (ev) {
		elKnows.forEach(function (el) {
			var knowId = el.dataset.knowid
			if (knowId == slKnow.value) {
				activeKnowTag(el)
			}
		})
	})
</script>
</body>
</html>