{x2;if:!$userhash}
{x2;include:header}

<!-- 引入样式 -->
<link rel="stylesheet" href="/files/public/element-ui/lib/theme-chalk/index.css">
<!-- 引入组件库 -->
<script src="/files/public/vue/dist/vue.js"></script>
<script src="/files/public/element-ui/lib/index.js"></script>

<body>
{x2;include:nav}
<div class="container-fluid" id="root">
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
							<li class="active">题库管理</li>
						</ol>
					</div>
				</div>
				<div class="box itembox" style="padding-top:10px;margin-bottom:0px;">
					<h4 class="title" style="padding:10px;">
						题库管理
						<a class="btn btn-primary pull-right" href="index.php?exam-master-basic-addsubject">添加题库</a>
					</h4>
			        <table class="table table-hover table-bordered">
						<thead>
							<tr class="info">
			                    <th width="80">题库ID</th>
								<th>题库名称</th>
								<th width="220">操作</th>
			                </tr>
			            </thead>
			            <tbody>
		                    {x2;tree:$subjects,subject,sid}
							<tr>
								<td>{x2;v:subject['subjectid']}</td>
								<td>
									<el-button type="text" @click="openSectionList({x2;v:subject['subjectid']})">{x2;v:subject['subject']}</el-button>
								</td>
								<td>
									<!--<div class="btn-group">
										<a class="btn ajax" href="index.php?exam-master-basic-clearpoint&subjectid={x2;v:subject['subjectid']}" title="更新缓存"><em class="glyphicon glyphicon-refresh"></em></a>
										<a class="btn ajax" href="index.php?exam-master-basic-output&subjectid={x2;v:subject['subjectid']}&page={x2;$page}{x2;$u}" title="导出题库"><em class="glyphicon glyphicon-download-alt"></em></a>
										<a class="btn" href="index.php?exam-master-basic-section&subjectid={x2;v:subject['subjectid']}&page=1&basicid={x2;v:basic['basicid']}{x2;$u}" title="章节列表"><em class="glyphicon glyphicon-th-list"></em></a>
										<a class="btn" href="index.php?exam-master-basic-modifysubject&subjectid={x2;v:subject['subjectid']}&page={x2;$page}{x2;$u}" title="修改题库信息"><em class="glyphicon glyphicon-edit"></em></a>
										<a class="btn ajax" href="index.php?exam-master-basic-delsubject&subjectid={x2;v:subject['subjectid']}&page={x2;$page}{x2;$u}" title="删除题库"><em class="glyphicon glyphicon-remove"></em></a>
									</div> -->
									<a role="button" class="btn btn-primary btn-xs ajax" href="index.php?exam-master-basic-clearpoint&subjectid={x2;v:subject['subjectid']}" title="更新缓存">更新缓存</a>
									<a role="button" class="btn btn-primary btn-xs ajax" href="index.php?exam-master-basic-output&subjectid={x2;v:subject['subjectid']}&page={x2;$page}{x2;$u}" title="导出题库">导出题库</a>
									<a role="button" class="btn btn-primary btn-xs" href="index.php?exam-master-basic-section&subjectid={x2;v:subject['subjectid']}&page=1&basicid={x2;v:basic['basicid']}{x2;$u}" title="章节列表">章节列表</a>
									<a role="button" class="btn btn-primary btn-xs" href="index.php?exam-master-basic-modifysubject&subjectid={x2;v:subject['subjectid']}&page={x2;$page}{x2;$u}" title="修改题库信息">修改题库信息</a>
									<a role="button" class="btn btn-danger btn-xs ajax confirm" href="index.php?exam-master-basic-delsubject&subjectid={x2;v:subject['subjectid']}&page={x2;$page}{x2;$u}" title="删除题库">删除题库</em></a>
								</td>
							</tr>
							{x2;endtree}
			        	</tbody>
			        </table>
				</div>
			</div>
{x2;if:!$userhash}
		</div>
	</div>

	<el-dialog
			title="章节信息"
			:visible.sync="dialogVisible"
			width="50%"
			:destroy-on-close="true"
	>
		<div style="min-height: 300px" v-loading="loading">
			<el-tree v-if="dialogVisible" :props="defaultProps" lazy :load="loadNode">
				<span class="custom-tree-node" slot-scope="{ node, data }">
					<span>{{ data.label }}</span>
					<span><el-tag size="mini">ID: {{ data.id }}</el-tag></span>
			  	</span>
			</el-tree>
		</div>
	</el-dialog>
</div>

{x2;include:footer}

<script>
	new Vue({
		el: '#root',
		data: function() {
			return {
				dialogVisible: false,
				loading: false,
				defaultProps: {
					children: 'children',
					label: 'label',
					isLeaf: 'isLeaf'
				},
				currentSubjectId: 0
			}
		},
		methods: {
			loadNode(node, resolve) {
				if (node.level > 1) return resolve([]);

				if (node.level === 0) {
					$.ajax({
						url: `/index.php?exam-master-basic-subjectsection&id=${this.currentSubjectId}`,
						success: (res) => {
							res = JSON.parse(res)
							if (res.code !== 200) return this.$message.error(res.msg);
							resolve(res.data.map(item => ({id: item.sectionid, label: item.section, children: []})))
						},
						complete: () => {
							this.loading = false
						}
					})
				} else {
					$.ajax({
						url: `/index.php?exam-master-basic-sectionknow&id=${node.data.id}`,
						success: (res) => {
							res = JSON.parse(res)
							if (res.code !== 200) return this.$message.error(res.msg);
							resolve(res.data.map(item => ({id: item.knowsid, label: item.knows, children: [], isLeaf: true})))
						},
					})
				}
			},

			openSectionList(id) {
				this.dialogVisible = true
				this.loading = true
				this.currentSubjectId = id
			}
		}
	})
</script>

</body>
</html>
{x2;endif}