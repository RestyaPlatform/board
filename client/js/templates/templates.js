this["JST"] = this["JST"] || {};

this["JST"]["templates/about_us"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="about-block col-xs-pull-0 col-xs-push-0">\n\t<h1><a title="' +
__e( SITE_NAME ) +
'" href="javascript:void(0);"><img src="img/logo.png" alt="[Image: ' +
__e( SITE_NAME ) +
' ]" title="' +
__e( SITE_NAME ) +
'" class="img-responsive center-block"/></a> </h1>\n\t<small class="show text-center">v 0.3 (2016-06-30)</small>\n\t<h3>' +
__e( i18next.t("Technologies and Components") ) +
'</h3>\n\t\t<ul class="list-unstyled">\n\t\t\t<li>Restya platform <a class="text-primary" target="_blank" title="http://restya.com/?utm_source=Restyaboard - ' +
__e( SITE_NAME ) +
'&utm_medium=web&utm_campaign=about_us" href="http://restya.com/">http://restya.com/ </a></li>\n\t\t\t<li>Backbone.js <a class="text-primary" target="_blank" title="http://backbonejs.org/" href="http://backbonejs.org/ ">http://backbonejs.org/ </a></li>\n\t\t\t<li>Underscore <a class="text-primary" target="_blank" title="http://underscorejs.org" href="http://underscorejs.org">http://underscorejs.org </a></li>\n\t\t\t<li>jQuery <a class="text-primary" target="_blank" title="http://jquery.com/" href="http://jquery.com/">http://jquery.com/ </a></li>\n\t\t\t<li>jQuery UI <a class="text-primary" target="_blank" title="http://jqueryui.com" href="http://jqueryui.com">http://jqueryui.com </a></li>\n\t\t\t<li>Bootstrap3 <a class="text-primary" target="_blank" title="http://getbootstrap.com/" href="http://getbootstrap.com/">http://getbootstrap.com/ </a></li>\n\t\t\t<li>Font Awesome <a class="text-primary" target="_blank" title="http://fortawesome.github.io/Font-Awesome/" href="http://fortawesome.github.io/Font-Awesome/">http://fortawesome.github.io/Font-Awesome/ </a></li>\n\t\t\t<li>Dockmodal <a class="text-primary" target="_blank" title="http://uxmine.com/demo/dockmodal/" href="http://uxmine.com/demo/dockmodal/">http://uxmine.com/demo/dockmodal/ </a></li>\n\t\t\t<li>FullCalendar <a class="text-primary" target="_blank" title="http://fullcalendar.io/" href="http://fullcalendar.io/">http://fullcalendar.io/ </a></li>\n\t\t\t<li>Gantt <a class="text-primary" target="_blank" title="http://taitems.github.io/jQuery.Gantt/" href="http://taitems.github.io/jQuery.Gantt/">http://taitems.github.io/jQuery.Gantt/ </a></li>\n\t\t\t<li>Markdown Converter <a class="text-primary" target="_blank" title="https://github.com/showdownjs/showdown" href="https://github.com/showdownjs/showdown">https://github.com/showdownjs/showdown </a></li>\n\t\t\t<li>Select2 <a class="text-primary" target="_blank" title="https://select2.github.io/" href="https://select2.github.io/">https://select2.github.io/ </a></li>\n\t\t\t<li>Fileupload <a class="text-primary" target="_blank" title="https://blueimp.github.io/jQuery-File-Upload/" href="https://blueimp.github.io/jQuery-File-Upload/">https://blueimp.github.io/jQuery-File-Upload/ </a></li>\n\t\t\t<li>Emoji <a class="text-primary" target="_blank" title="http://hassankhan.me/emojify.js/" href="http://hassankhan.me/emojify.js/">http://hassankhan.me/emojify.js/ </a></li>\n\t\t\t<li>Doughnut Chart <a class="text-primary" target="_blank" title="https://github.com/githiro/drawDoughnutChart" href="https://github.com/githiro/drawDoughnutChart">https://github.com/githiro/drawDoughnutChart </a></li>\n\t\t\t<li>Dualstorage <a class="text-primary" target="_blank" title="https://github.com/nilbus/Backbone.dualStorage" href="https://github.com/nilbus/Backbone.dualStorage">https://github.com/nilbus/Backbone.dualStorage </a></li>\n\t\t\t<li>Backbone Batch Operations <a class="text-primary" target="_blank" title="https://github.com/akiomik/backbone-batch-operations/" href="https://github.com/akiomik/backbone-batch-operations/">https://github.com/akiomik/backbone-batch-operations/ </a></li>\n\t\t\t<li>Timeago <a class="text-primary" target="_blank" title="http://timeago.yarp.com/" href="http://timeago.yarp.com/">http://timeago.yarp.com/ </a></li>\n\t\t\t<li>Flickr <a class="text-primary" target="_blank" title="https://www.flickr.com/services/api/" href="https://www.flickr.com/services/api/">https://www.flickr.com/services/api/ </a></li>\n\t\t\t<li>Musical <a class="text-primary" target="_blank" title="https://github.com/PencilCode/musical.js" href="https://github.com/PencilCode/musical.js">https://github.com/PencilCode/musical.js </a></li>\n\t\t\t<li>Dropbox <a class="text-primary" target="_blank" title="https://www.dropbox.com/developers/dropins/chooser/js" href="https://www.dropbox.com/developers/dropins/chooser/js">https://www.dropbox.com/developers/dropins/chooser/js </a></li>\n\t\t\t<li>PostgreSQL <a class="text-primary" target="_blank" title="http://www.postgresql.org" href="http://www.postgresql.org">http://www.postgresql.org </a></li>\n\t\t\t<li>Finediff <a class="text-primary" target="_blank" title="http://www.raymondhill.net/finediff/" href="http://www.raymondhill.net/finediff/">http://www.raymondhill.net/finediff/ </a></li>\n\t\t\t<li>OAuth <a class="text-primary" target="_blank" title="http://bshaffer.github.io/oauth2-server-php-docs/" href="http://bshaffer.github.io/oauth2-server-php-docs/">http://bshaffer.github.io/oauth2-server-php-docs/ </a></li>\n\t\t\t<li>ElasticSearch <a class="text-primary" target="_blank" title="https://www.elastic.co/" href="https://www.elastic.co/">https://www.elastic.co/ </a></li>\n\t\t\t<li>Grunt <a class="text-primary" target="_blank" title="http://gruntjs.com/" href="http://gruntjs.com/">http://gruntjs.com/ </a></li>\n\t\t\t<li>Swagger UI <a class="text-primary" target="_blank" title="http://swagger.io/swagger-ui/" href="http://swagger.io/swagger-ui/">http://swagger.io/swagger-ui/ </a></li>\n\t\t\t<li>XMPP chat <a class="text-primary" target="_blank" title="http://conversejs.org" href="http://conversejs.org">http://conversejs.org </a></li>\n\t\t\t<li>Custom fields <a class="text-primary" target="_blank" title="http://github.com/powmedia/backbone-forms" href="http://github.com/powmedia/backbone-forms">http://github.com/powmedia/backbone-forms </a></li>\n\t\t\t<li>Sparkline <a class="text-primary" target="_blank" title="http://omnipotent.net/jquery.sparkline/" href="http://omnipotent.net/jquery.sparkline/">http://omnipotent.net/jquery.sparkline/ </a></li>\n\t\t</ul>\n</div>';

}
return __p
};

this["JST"]["templates/activity"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(!_.isEmpty(activity) && activity != null){ ;
__p += ' \n';
 var unread = ""; ;
__p += '\n';
 if(!_.isUndefined(activity.from_footer) && parseInt(activity.attributes.id) > parseInt(authuser.user.unread_activity_id)){ ;
__p += '\n\t ';
if(parseInt(activity.attributes.user_id) !== parseInt(authuser.user.id)){;
__p += ' \n\t ';
 var unread = "js-unread-activity"; ;
__p += ' \n\t <span class="label label-primary col-xs-12 sr-only">&nbsp;</span>   \n\t';
};
__p += '    \n';
 } ;
__p += '                   \n<div class="media ' +
((__t = ( unread )) == null ? '' : __t) +
'  modal-';
 if((activity.attributes.type == 'add_comment' ||  activity.attributes.type == 'edit_comment')) {;
__p += 'comments';
} else { ;
__p += 'activities';
};
__p += ' ';
 if(!_.isUndefined(authuser.user) &&  activity.attributes.user_id == authuser.user.id) {;
__p += 'modal-logged-user-activities';
};
__p += '">\n<a data-placement="bottom" title="' +
__e(activity.attributes.full_name ) +
' (' +
__e(activity.attributes.username ) +
')" data-toggle="tooltip" data-container="body" data-html="true" class="js-tooltip pull-left" href="#/user/' +
__e( activity.attributes.user_id ) +
'">\n\t\t';
 if(!_.isEmpty(activity.attributes.profile_picture_path)) {
			var profile_picture_path = activity.showImage('User', activity.attributes.user_id, 'small_thumb' );
	 	;
__p += '      \n\t\t\t<img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(activity.attributes.full_name ) +
']" title="' +
__e(activity.attributes.full_name ) +
' (' +
__e(activity.attributes.username ) +
')" class="img-rounded img-responsive">\n\t\t';
 } else {;
__p += ' \n\t\t\t<i class="avatar avatar-color-194 img-rounded">' +
__e( activity.attributes.initials ) +
'</i>\n\t\t';
 } ;
__p += '       \n\t</a>\n\t<div class="media-body">   \n    \t';
 if(activity.attributes.type == 'add_comment' && activity.attributes.type == 'edit_comment' ) { ;
__p += '\n\t\t<div class="media-heading">\t\t\t\n\t\t\t\n            <span class="js-activity-' +
__e( activity.attributes.id ) +
'">' +
((__t = ( converter.makeHtml(makeLink(''+ _.escape(activity.attributes.comment), activity.attributes.board_id)) )) == null ? '' : __t) +
'</span>\n\t\t</div>   \n        ';
 } else {;
__p += '\n\t\t';
 
			var cardLink = '<a href="#/board/' + activity.attributes.board_id + '/card/' + activity.attributes.card_id + '">' + _.escape(activity.attributes.card_name) + '</a>';
			var organizationLink = '<a href="#/organization/' + activity.attributes.organization_id + '">' + _.escape(activity.attributes.organization_name) + '</a>';
			if(activity.attributes.type != 'add_comment' && activity.attributes.type != 'edit_comment') {
				activity.attributes.comment = activity.attributes.comment.replace('##ORGANIZATION_LINK##', organizationLink);
				activity.attributes.comment = activity.attributes.comment.replace('##CARD_LINK##', cardLink);
				activity.attributes.comment = activity.attributes.comment.replace('##LABEL_NAME##', _.escape(activity.attributes.label_name));
				activity.attributes.comment = activity.attributes.comment.replace('##CARD_NAME##', _.escape(activity.attributes.card_name));
				activity.attributes.comment = activity.attributes.comment.replace('##DESCRIPTION##', _.escape(activity.attributes.card_description));
				activity.attributes.comment = activity.attributes.comment.replace('##LIST_NAME##', _.escape(activity.attributes.list_name));
				activity.attributes.comment = activity.attributes.comment.replace('##BOARD_NAME##', _.escape(activity.attributes.board_name));
				activity.attributes.comment = activity.attributes.comment.replace('##USER_NAME##', '<span class="h5">'+_.escape(activity.attributes.full_name)+'</span>');
				activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_ITEM_NAME##', _.escape(activity.attributes.checklist_item_name));
				activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_ITEM_PARENT_NAME##', _.escape(activity.attributes.checklist_item_parent_name));
				activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_NAME##', _.escape(activity.attributes.checklist_name));
			} else {
				if(!_.isUndefined(activity.from_footer)) {
					var comment = '<span class="h5">' + activity.attributes.full_name + '</span> commented in card ' + cardLink;
					var matches = activity.attributes.comment.match(/@([^ ]*)/g);
					var _username = [];
					_.each(matches, function(match) {
						_username.push(match.substr(1));
					});
					if(_.contains(_username, authuser.user.username)){
						comment = activity.attributes.full_name + ' has mentioned you in card ' + cardLink;
					}
				} 
			}
		;
__p += '             \n\t\t<div class="col-xs-12 btn-block">  \n\t\t\t\t\t<div class="activities-list js-activity-' +
__e( activity.attributes.id ) +
'">\n\t\t\t\t\t';
 if((activity.attributes.type == 'add_comment' || activity.attributes.type == 'edit_comment')) { ;
__p += '\n\t\t\t\t\t\t';
if(!_.isUndefined(activity.from_footer)) { ;
__p += '\n\t\t\t\t\t\t\t<span>' +
((__t = ( comment )) == null ? '' : __t) +
'</span>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t<div class="panel no-mar"><div class="panel-body">\n\n\t\t\t\t\t\t\t' +
((__t = ( converter.makeHtml(makeLink(activity.attributes.comment, activity.attributes.board_id)) )) == null ? '' : __t) +
'\n\t\t\t\t\t\t\t';
 if(activity.attributes.difference != null && _.contains(['update_card_comment', 'edit_list', 'edit_organization', 'edit_board', 'update_card_checklist', 'update_profile', 'edit_card'], activity.attributes.type)) { ;
__p += '\n\t\t\t\t\t\t<div class="';
if(!_.isUndefined(activity.from_footer)) { ;
__p += 'thumbnail';
 } ;
__p += ' list-group-item-text">\n\t\t\t\t\t\t\t';
 _.each(activity.attributes.difference, function(difference) { ;
__p += '\n\t\t\t\t\t\t\t\t' +
((__t = ( converter.makeHtml(difference) )) == null ? '' : __t) +
'\n\t\t\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t\t\t</div>\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t</div></div>\n\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t';
if(_.isUndefined(activity.from_footer)) { ;
__p += '\n\t\t\t\t\t\t\t<div class="panel no-mar"><div class="panel-body">\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t' +
((__t = ( converter.makeHtml(makeLink(activity.attributes.comment, activity.attributes.board_id)) )) == null ? '' : __t) +
'\n\t\t\t\t\t\t\t';
 if(activity.attributes.difference != null && _.contains(['update_card_comment', 'edit_list', 'edit_organization', 'edit_board', 'update_card_checklist', 'update_profile', 'edit_card'], activity.attributes.type)) { ;
__p += '\n\t\t\t\t\t\t<div class="';
if(!_.isUndefined(activity.from_footer)) { ;
__p += 'thumbnail';
 } ;
__p += ' list-group-item-text">\n\t\t\t\t\t\t\t';
 _.each(activity.attributes.difference, function(difference) { ;
__p += '\n\t\t\t\t\t\t\t\t' +
((__t = ( converter.makeHtml(difference) )) == null ? '' : __t) +
'\n\t\t\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t\t\t</div>\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t';
if(_.isUndefined(activity.from_footer)) { ;
__p += '\n\t\t\t\t\t\t\t</div></div>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t';
 };
__p += '\n\t\t\t\t\t<small class="pull-left">\n\t\t\t<abbr class="timeago text-muted pull-left clearfix" title="' +
__e( activity.attributes.created ) +
'">' +
__e( activity.attributes.created ) +
'</abbr>\n\t\t\t';
 if((activity.attributes.type == 'add_organization_attachment' || activity.attributes.type == 'change_visibility' || activity.attributes.type == 'add_organization_user' || activity.attributes.type == 'delete_organization_user') && (!_.isEmpty(activity.attributes.organization_name))) { ;
__p += '\n\t\t\t\t<a href="#/organization/' +
((__t = ( activity.attributes.organization_id )) == null ? '' : __t) +
'">&nbsp;' +
__e( i18next.t("on") ) +
'&nbsp;' +
__e( activity.attributes.organization_name ) +
'</a>\n\t\t\t';
 } else if(type == 'all' && activity.attributes.type != 'edit_organization' && activity.attributes.type != 'add_organization' && (!_.isEmpty(activity.attributes.board_name))) { ;
__p += '\n\t\t\t\t<a class="pull-left" href="#/board/' +
((__t = ( activity.attributes.board_id )) == null ? '' : __t) +
'">&nbsp;' +
__e( i18next.t("on") ) +
'&nbsp;' +
__e( activity.attributes.board_name ) +
'</a>\n\t\t\t';
 } ;
__p += '\n\t\t\t\t';
 if(!_.isUndefined(authuser.user) && activity.attributes.type == "add_comment" && type != "all" && (_.isUndefined(activity.from_footer))) { ;
__p += '\n\t\t\t\t\t<div class="js-acticity-action-' +
__e( activity.attributes.id ) +
' pull-left navbar-btn col-xs-8">\n\t\t\t\t\t\t<ul class="list-inline">\n\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "edit_comment", board_user_role_id: parseInt(activity.board_user_role_id)})))){ ;
__p += '\n\t\t\t\t\t\t\t<li><a title="Edit" class="js-show-edit-activity js-edit-activity-link-' +
__e( activity.attributes.id ) +
'" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"  data-activity-temp-id="' +
__e( activity.attributes.temp_id ) +
'"><i class="icon-edit"></i>' +
__e( i18next.t("Edit") ) +
'</a></li>\n\t\t\t\t\t\t';
 } ;
__p += ' \n\t\t\t\t\t\t\t<li><a title="Reply" class="js-show-reply-activity-form js-reply-activity-link-' +
__e( activity.attributes.id ) +
'" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-repeat"></i>' +
__e( i18next.t("Reply") ) +
'</a></li>\n\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "delete_comment", board_user_role_id: parseInt(activity.board_user_role_id)})))){ ;
__p += '\n\t\t\t\t\t\t\t\t<li class="dropdown">\n\t\t\t\t\t\t\t\t\t<a title="Delete" class="dropdown-toggle js-show-confirm-comment-delete" data-toggle="dropdown" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-remove"></i>' +
__e( i18next.t("Delete") ) +
'</a>\n\t\t\t\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t\t\t\t\t\t<li id="js-acticity-actions-response-' +
__e( activity.attributes.id ) +
'" class="js-dropdown-popup dropdown-popup"></li>\n\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t</div>\n\t\t\t\t';
 } else if(activity.attributes.revisions != null && activity.attributes.revisions != "" && !_.isUndefined(authuser.user)){ ;
__p += '\n\t\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "undo_activity"}))){ ;
__p += '\n\t\t\t\t\t\t';
 if(!_.isUndefined(activity.from_footer)) { ;
__p += '\n\t\t\t\t\t\t\t<div class="js-acticity-action-' +
__e( activity.attributes.id ) +
'"><ul class="list-inline"><li><a title="Undo" class="js-undo2 col-xs-12 nav navbar-btn" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-undo"></i>' +
__e( i18next.t("Undo") ) +
'</a></li></ul></div>\t\t\t\t\t\t\t\n\t\t\t\t\t\t';
 } else { ;
__p += '\t\n\t\t\t\t\t\t\t<div class="js-acticity-action-' +
__e( activity.attributes.id ) +
'"><ul class="list-inline"><li><a title="Undo" class="js-undo col-xs-12 nav navbar-btn" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-undo"></i>' +
__e( i18next.t("Undo") ) +
'</a></li></ul></div>\n\t\t\t\t\t\t';
 };
__p += '\t\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t<span class="pull-left col-xs-12 js-activity-reply-form-response-' +
__e( activity.attributes.id ) +
'"></span>\n\t\t</small>\n\t\t\t\t\t</div>\n\t\t</div>\n        ';
 } ;
__p += '\n\t</div>\n</div>\n\n\n\n\t';
 if(_.isEmpty(unread)){ ;
__p += ' \n\t\t<hr class="clearfix col-xs-12 btn-block"/>\n\t';
};
__p += '\n\t';
 if(!_.isEmpty(unread)){ ;
__p += '\n\t\t<div class="well-sm clearfix"></div>\n\t';
};
__p += '\n';
 }else{ ;
__p += '<div class="media-body alert alert-info">' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('activities')] }) ) +
'</div>';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/activity_add_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="form-group required"><textarea id="inputAddComment" name="comment" class="form-control" placeholder="Write a comment"  title="Write a comment" required></textarea></div><div class="submit"><input type="hidden" name="list_id" id="ListID" value="' +
__e( card.attributes.list_id ) +
'"> <input type="hidden" name="card_id" id="CardID" value="' +
__e( card.attributes.id ) +
'"> <input type="submit" id="submitCommentAdd" class="btn btn-primary" value="Comment"></div>';

}
return __p
};

this["JST"]["templates/activity_card_search"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(card != null){ ;
__p += '\n<a title="' +
__e( card.attributes.name ) +
'" href="#" class="js-add-comment-card" data-board-id="' +
__e( card.attributes.board_id ) +
'" data-card-id="' +
__e( card.id ) +
'" data-card-name="' +
__e( card.attributes.name ) +
'"><span>' +
__e( card.attributes.name ) +
'</span></a>\n';
}else{;
__p += '\n<span class="alert alert-info">\n' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('cards')] }) ) +
'\n</span>\n';
};
__p += '\n';

}
return __p
};

this["JST"]["templates/activity_delete_confirm"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12"><span class="col-xs-10"><strong>' +
__e( i18next.t("Delete Comment") ) +
'?</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a></div><div class="divider col-xs-12"></div><div class="col-xs-12"><p>' +
__e( i18next.t("Deleting a comment is forever. There is no undo.") ) +
'</p><a class="js-delete-comment btn btn-primary" title="Delete" data-activity-id="' +
__e( activity_id ) +
'">' +
__e( i18next.t("Delete") ) +
'</a></div>';

}
return __p
};

this["JST"]["templates/activity_index"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="well-sm"></div>\n<ul class="clearfix list-unstyled" id="js-admin-activity-list">\n\n</ul>\n<div class="btn btn-primary hide" id="js-admin-activites-load-more">' +
__e( i18next.t("Load more activities") ) +
'</div>';

}
return __p
};

this["JST"]["templates/activity_reply_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="required form-group"><textarea rows="4" id="inputAddComment" name="comment" class="form-control" placeholder="' +
__e( i18next.t('Write a comment') ) +
'" title="' +
__e( i18next.t('Write a comment') ) +
'" required></textarea></div><div class="submit"><input type="hidden" name="list_id" id="ListID" value="' +
__e( activity.attributes.list_id) +
'"> <input type="hidden" name="card_id" id="CardID" value="' +
__e( activity.attributes.card_id) +
'"> <input type="hidden" name="root" id="RootID" value="' +
__e( activity.attributes.id) +
'"> <input type="submit" id="submitCommentAdd" class="btn btn-primary" value="' +
__e( i18next.t('Reply') ) +
'"> <i class="icon-remove js-hide-reply-comment-form btn btn-link cur" title="' +
__e( i18next.t('Cancel') ) +
'" data-activity-id="' +
__e( activity.attributes.id) +
'"></i></div>';

}
return __p
};

this["JST"]["templates/activity_user_add_search_result"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(user != null) { ;
__p += '<li><a title="' +
__e(user.attributes.full_name ) +
' (' +
__e(user.attributes.username ) +
')" href="#" class="js-add-comment-member" data-user-id="' +
__e(user.id ) +
'" data-user-name="' +
__e(user.attributes.username ) +
'" data-user-initial="' +
__e(user.attributes.initials ) +
'" data-user-profile-picture-path="' +
__e(user.attributes.profile_picture_path) +
'" data-user-fullname="' +
__e(user.attributes.full_name ) +
'><span>\n';
 if(!_.isEmpty(user.attributes.profile_picture_path)) { 
	var profile_picture_path = user.showImage('User', user.attributes.user_id, 'micro_thumb' );
;
__p += '\n<img src="' +
__e(profile_picture_path ) +
'" alt="[Image: ' +
__e(user.attributes.username ) +
']" title="' +
__e(user.attributes.full_name ) +
' (' +
__e(user.attributes.username ) +
')" class="img-rounded img-responsive avatar avatar-sm">';
 } else {;
__p += ' <i class="avatar avatar-color-194 avatar-sm img-rounded">' +
__e( user.attributes.initials ) +
'</i>';
 } ;
__p += '</span> <span>' +
__e(user.attributes.full_name ) +
' (' +
__e(user.attributes.username ) +
')</span></a></li>';
 }else{ ;
__p += '<li><span class="alert alert-info"> ' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('users')] }) ) +
'</span></li>';
};
__p += '\n\n';

}
return __p
};

this["JST"]["templates/admin_activity_index"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(!_.isEmpty(activity) && activity != null){ ;
__p += ' \n';
 
	var cardLink = '<a href="#/board/' + activity.attributes.board_id + '/card/' + activity.attributes.card_id + '">' + _.escape(activity.attributes.card_name) + '</a>';
	var organizationLink = '<a href="#/organization/' + activity.attributes.organization_id + '">' + _.escape(activity.attributes.organization_name) + '</a>';
	if(activity.attributes.type != 'add_comment' && activity.attributes.type != 'edit_comment') {
		activity.attributes.comment = activity.attributes.comment.replace('##ORGANIZATION_LINK##', organizationLink);
		activity.attributes.comment = activity.attributes.comment.replace('##CARD_LINK##', cardLink);
		activity.attributes.comment = activity.attributes.comment.replace('##LABEL_NAME##', _.escape(activity.attributes.label_name));
		activity.attributes.comment = activity.attributes.comment.replace('##CARD_NAME##', _.escape(activity.attributes.card_name));
		activity.attributes.comment = activity.attributes.comment.replace('##DESCRIPTION##', _.escape(activity.attributes.card_description));
		activity.attributes.comment = activity.attributes.comment.replace('##LIST_NAME##', _.escape(activity.attributes.list_name));
		activity.attributes.comment = activity.attributes.comment.replace('##BOARD_NAME##', _.escape(activity.attributes.board_name));
		activity.attributes.comment = activity.attributes.comment.replace('##USER_NAME##', '<span class="h5">'+_.escape(activity.attributes.full_name)+'</span>');
		activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_ITEM_NAME##', _.escape(activity.attributes.checklist_item_name));
		activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_ITEM_PARENT_NAME##', _.escape(activity.attributes.checklist_item_parent_name));
		activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_NAME##', _.escape(activity.attributes.checklist_name));
	} else {
			var comment = activity.attributes.full_name + ' commented in card ' + cardLink;
			var matches = activity.attributes.comment.match(/@([^ ]*)/g);
			var _username = [];
			_.each(matches, function(match) {
				_username.push(match.substr(1));
			});
			if(_.contains(_username, authuser.user.username)){
				comment = activity.attributes.full_name + ' has mentioned you in card ' + cardLink;
			}
	}
;
__p += '\n<div class="media">\n\t<a data-placement="bottom" title="' +
__e(activity.attributes.full_name ) +
' (' +
__e(activity.attributes.username ) +
')" data-toggle="tooltip" class="js-tooltip pull-left" href="#/user/' +
__e( activity.attributes.user_id ) +
'">\n\t\t';
 if(!_.isEmpty(activity.attributes.profile_picture_path)) {
			var profile_picture_path = activity.showImage('User', activity.attributes.user_id, 'small_thumb' );
		;
__p += '\n\t\t\t<img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(activity.attributes.full_name ) +
']" title="' +
__e(activity.attributes.full_name ) +
' (' +
__e(activity.attributes.username ) +
')" class="img-rounded img-responsive avatar">\n\t\t';
 } else {;
__p += ' \n\t\t\t<i class="avatar avatar-color-194 img-rounded">' +
__e( activity.attributes.initials ) +
'</i>\n\t\t';
 } ;
__p += '\n\t</a>\n\t<div class="media-body"> <!-- Condition for comment activities design -->\n    \t';
 if(activity.attributes.type != 'add_comment' && activity.attributes.type != 'add_card_duedate') { ;
__p += '\n\t\t<div class="media-heading">\t\t\t\n            <span class="js-activity-' +
__e( activity.attributes.id ) +
'">\n\t\t\t\t';
 if(activity.attributes.type == 'add_comment' || activity.attributes.type == 'edit_comment') { ;
__p += '\t\n\t\t\t\t\t<span>' +
((__t = ( comment )) == null ? '' : __t) +
'</span>\n\t\t\t\t\t' +
((__t = ( converter.makeHtml(makeLink(_.escape(activity.attributes.comment), activity.attributes.board_id)) )) == null ? '' : __t) +
'\n\t\t\t\t';
 } else{;
__p += '\n\t\t\t\t\t' +
((__t = ( converter.makeHtml(makeLink(activity.attributes.comment, activity.attributes.board_id)) )) == null ? '' : __t) +
' \n\t\t\t\t';
 } ;
__p += '\n\t\t\t</span>\n            ';
 if(activity.attributes.difference != null && _.contains(['update_card_comment', 'edit_list', 'edit_organization', 'edit_board', 'update_card_checklist', 'update_profile', 'edit_card'], activity.attributes.type)) { ;
__p += '\n                <div class="thumbnail media-body no-mar">\n\t\t\t\t\t';
 _.each(activity.attributes.difference, function(difference) { ;
__p += '\n\t\t\t\t\t\t' +
((__t = ( converter.makeHtml(difference) )) == null ? '' : __t) +
'\n\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t</div>\n            ';
 } ;
__p += '\n\t\t</div>   \n        ';
 } else {;
__p += '             \n\t\t<div class="col-xs-12 row">\n\t\t\t<div class="panel no-mar">\n\t\t\t\t<div class="panel-body">\n\t\t\t\t\t<span class="js-activity-' +
__e( activity.attributes.id ) +
'">\n\t\t\t\t\t\t';
 if(activity.attributes.type == 'add_comment' || activity.attributes.type == 'edit_comment') { ;
__p += '\t\n\t\t\t\t\t\t\t<span>' +
((__t = ( comment )) == null ? '' : __t) +
'</span>\n\t\t\t\t\t\t\t' +
((__t = ( converter.makeHtml(makeLink(_.escape(activity.attributes.comment), activity.attributes.board_id)) )) == null ? '' : __t) +
'\n\t\t\t\t\t\t';
 } else{;
__p += '\n\t\t\t\t\t\t\t' +
((__t = ( converter.makeHtml(makeLink(activity.attributes.comment, activity.attributes.board_id)) )) == null ? '' : __t) +
' \n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t</span>\n\t\t\t\t\t';
 if(activity.attributes.difference != null && _.contains(['update_card_comment', 'edit_list', 'edit_organization', 'edit_board', 'update_card_checklist', 'update_profile', 'edit_card'], activity.attributes.type)) { ;
__p += '\n\t\t\t\t\t\t<div class="thumbnail media-body no-mar">' +
((__t = ( converter.makeHtml(activity.attributes.difference[0]) )) == null ? '' : __t) +
'</div>\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\n\t\t\t\t</div>\n\t\t\t</div>\t\t\n\t\t</div>\n        ';
 } ;
__p += '\n\t</div>\n</div>\n<div class="clearfix col-xs-12">\n\t<div class="clearfix col-xs-12">\n\t\t<small class="col-xs-12 pull-left">\n\t\t\t<abbr class="timeago pull-left text-muted" title="' +
__e( activity.attributes.created ) +
'">' +
__e( activity.attributes.created ) +
'</abbr>\n\t\t\t';
 if((activity.attributes.type == 'add_organization_attachment' || activity.attributes.type == 'change_visibility' || activity.attributes.type == 'add_organization_user' || activity.attributes.type == 'delete_organization_user') && (!_.isEmpty(activity.attributes.organization_name))) { ;
__p += '\n\t\t\t\t<a class="pull-left" href="#/organization/' +
((__t = ( activity.attributes.organization_id )) == null ? '' : __t) +
'">&nbsp;' +
__e( i18next.t('on') ) +
'&nbsp;' +
__e( activity.attributes.organization_name ) +
'</a>\n\t\t\t';
 } else if((type == 'all' && activity.attributes.type != 'update_profile' && activity.attributes.type != 'edit_organization' && activity.attributes.type != 'add_organization') && (!_.isEmpty(activity.attributes.board_name))) { ;
__p += '\n\t\t\t\t<a class="pull-left" href="#/board/' +
((__t = ( activity.attributes.board_id )) == null ? '' : __t) +
'">&nbsp;' +
__e( i18next.t('on') ) +
'&nbsp;' +
__e( activity.attributes.board_name ) +
'</a>\n\t\t\t';
 } ;
__p += '\n\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && activity.attributes.type == "add_comment" && type != "all") { ;
__p += '    \n\t\t\t\t\t\t<div class="js-acticity-action-' +
__e( activity.attributes.id ) +
' pull-left">\n\t\t\t\t\t\t\t<ul class="list-inline col-xs-offset-0">\n\t\t\t\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "edit_comment"}))){ ;
__p += '\n\t\t\t\t\t\t\t\t<li><a title="' +
__e( i18next.t('Edit') ) +
'" class="js-show-edit-activity js-edit-activity-link-' +
__e( activity.attributes.id ) +
'" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-edit"></i>' +
__e( i18next.t("Edit") ) +
'</a></li>\n\t\t\t\t\t\t\t';
 } ;
__p += ' \n\t\t\t\t\t\t\t\t<li><a title="' +
__e( i18next.t('Reply') ) +
'" class="js-show-reply-activity-form js-reply-activity-link-' +
__e( activity.attributes.id ) +
'" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-repeat"></i>' +
__e( i18next.t("Reply") ) +
'</a></li>\n\t\t\t\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "delete_comment"}))){ ;
__p += '\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\t<li class="dropdown">   \n\t\t\t\t\t\t\t\t\t\t<a title="' +
__e( i18next.t('Delete') ) +
'" class="dropdown-toggle js-show-confirm-comment-delete" data-toggle="dropdown" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-remove"></i>' +
__e( i18next.t("Delete") ) +
'</a>\n\t\t\t\t\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t\t\t\t\t\t\t<li id="js-acticity-actions-response-' +
__e( activity.attributes.id ) +
'" class="js-dropdown-popup dropdown-popup"></li>\n\t\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t';
 } else if(activity.attributes.revisions != null && activity.attributes.revisions != "" && (parseInt(authuser.user.id) == 1 || current_user_can_undo_it == true )){ ;
__p += '\n\t\t\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "undo_activity"}))){ ;
__p += '\n\t\t\t\t\t\t\t';
 if(_.isUndefined(activity.from_footer)) { ;
__p += '\n\t\t\t\t\t\t\t\t<div class="pull-left js-acticity-action-' +
__e( activity.attributes.id ) +
'"><ul class="list-inline col-xs-offset-0"><li><a title="' +
__e( i18next.t('Undo') ) +
'" class="js-undo2 pull-left" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-undo"></i>' +
__e( i18next.t("Undo") ) +
'</a></li></ul></div>\n\t\t\t\t\t\t\t';
 };
__p += '\t\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t<span class="pull-left col-xs-12 js-activity-reply-form-response-' +
__e( activity.attributes.id ) +
'"></span>\n\t\t</small>\n\t</div>\n</div>\n<hr class="clearfix col-xs-12 btn-block"/>\n';
 }else{ ;
__p += '<div class="media-body alert alert-info">' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('activities')] }) ) +
'</div>';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/admin_board_index"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(!_.isEmpty(role_links.where({slug: "view_my_boards"}))){ ;
__p += '\n  <div class="panel clearfix col-xs-12">    \n    <div class="well-sm"></div>\n\t<section class="clearfix">\n\t\t <div class="col-xs-12">\n\t\t\t<ul class="nav nav-pills text-center thumbnail js-filter-list">\n\t\t\t\t<li><a class="js-filter cur" data-filter="open" title="' +
__e( i18next.t('Open') ) +
'"><span class="show"><strong>' +
__e( filter_count.open ) +
'</strong></span>' +
__e( i18next.t('Open') ) +
'</a></li>\n\t\t\t\t<li><a class="js-filter cur" data-filter="closed" title="' +
__e( i18next.t('Closed') ) +
'"><span class="show"><strong>' +
__e( filter_count.closed ) +
'</strong></span>' +
__e( i18next.t('Closed') ) +
'</a></li>\n\t\t\t\t<li><a class="js-filter cur" data-filter="public" title="' +
__e( i18next.t('Public') ) +
'"><span class="show"><strong>' +
__e( filter_count.public ) +
'</strong></span>' +
__e( i18next.t('Public') ) +
'</a></li>\n\t\t\t\t<li><a class="js-filter cur" data-filter="private" title="' +
__e( i18next.t('Private') ) +
'"><span class="show"><strong>' +
__e( filter_count.private ) +
'</strong></span>' +
__e( i18next.t('Private') ) +
'</a></li>\n\t\t\t\t<li><a class="js-filter cur" data-filter="organization" title="' +
__e( i18next.t('Organization') ) +
'"><span class="show"><strong>' +
__e( filter_count.organization ) +
'</strong></span>' +
__e( i18next.t('Organization') ) +
'</a></li>\n\t\t\t\t';
 var all = parseInt(filter_count.open) + parseInt(filter_count.closed); ;
__p += '\n\t\t\t\t<li class="active"><a href="#/boards/list" title="' +
__e( i18next.t('All') ) +
'"><span class="show"><strong>' +
__e(  all ) +
'</strong></span>' +
__e( i18next.t('All') ) +
'</a></li>\n\t\t\t\t<li class="pull-right h4"><form id="BoardSearch" name="BoardSearch" class="form-horizontal col-xs-12"><input type="text" placeholder="Search" name="board_search" id="board_search" class="form-control" /></form></li>\n\t\t\t\t\n\t\t\t</ul>\n\t\t </div>\n\t</section>\n\t<section>\n\t\t<div class="well-sm"></div>\n\t\t<form role="form" class="col-xs-12">\n\t\t\t<div class="table-responsive">\n\t\t\t\t<table class="table table-striped table-bordered table-hover list-group-item-text">\n\t\t\t\t\t<thead> \n\t\t\t\t\t\t<tr class="active">\n\t\t\t\t\t\t  <th rowspan="2" class="text-center">' +
__e( i18next.t("Select") ) +
'</th>\n\t\t\t\t\t\t  <th rowspan="2" class="col-xs-2 text-center"><span class="js-sort cur" data-field="name" data-direction="desc"  title="' +
__e( i18next.t('Board Name') ) +
'"><span class="icon-caret-down"></span>' +
__e( i18next.t("Board") ) +
'</span></th>\n\t\t\t\t\t\t   <th rowspan="2" class="text-center"><span class="js-sort cur" data-field="organization_name" data-direction="desc"  title="Organization"><span class="icon-caret-down hide"></span>' +
__e( i18next.t("Organization") ) +
'</span></th>\n\t\t\t\t\t\t   <th rowspan="2" class="text-center col-xs-1"><span class="js-sort cur" data-field="username" data-direction="desc"  title="Created by"><span class="icon-caret-down hide"></span>' +
__e( i18next.t("Created by") ) +
'</span></th>\n\t\t\t\t\t\t   <th rowspan="2" class="text-center">' +
__e( i18next.t("Members") ) +
'</th>\n\t\t\t\t\t\t  <th colspan="2" class="text-center">' +
__e( i18next.t("List") ) +
'</th>\n\t\t\t\t\t\t  <th colspan="2" class="text-center">' +
__e( i18next.t("Card") ) +
'</th>\n\t\t\t\t\t\t  <th rowspan="2" class="text-center"><span class="js-sort cur" data-field="created" data-direction="desc"  title="' +
__e( i18next.t('Created') ) +
'"><span class="icon-caret-down hide"></span>' +
__e( i18next.t("Created") ) +
'</span></th>\n\t\t\t\t\t\t  <th rowspan="2" class="text-center"><span class="js-sort cur" data-field="modified" data-direction="desc"  title="' +
__e( i18next.t('Last activity') ) +
'"><span class="icon-caret-down hide"></span>' +
__e( i18next.t("Last activity") ) +
'</span></th>\n\t\t\t\t\t\t  <th rowspan="2" class="text-center th-width-sm">' +
__e( i18next.t("Visibility") ) +
'</th>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t<tr class="active">\n\t\t\t\t\t\t  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="list_count" data-direction="desc"  title="' +
__e( i18next.t('Open') ) +
'">' +
__e( i18next.t("Open") ) +
'</span></th>\n\t\t\t\t\t\t  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="archived_list_count" data-direction="desc"  title="' +
__e( i18next.t('Archived') ) +
'">' +
__e( i18next.t("Archived") ) +
'</span></th>\n\t\t\t\t\t\t  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="card_count" data-direction="desc"  title="' +
__e( i18next.t('Open') ) +
'">' +
__e( i18next.t("Open") ) +
'</span></th>\n\t\t\t\t\t\t  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="archived_card_count" data-direction="desc"  title="' +
__e( i18next.t('Archived') ) +
'">' +
__e( i18next.t("Archived") ) +
'</span></th>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t</thead>  \n\t\t\t\t\t<tbody class="js-my-boards">\n\t\t\t\t\t</tbody>\n                </table>\n\t        </div>\n        </form> \n        <div class="clearfix navbar-btn col-xs-12">\n\t\t\t  <div class="well-sm navbar-btn"></div>\n\t\t\t\t<ul class="list-inline pull-left">\n\t\t\t\t\t<li>' +
__e( i18next.t("Select") ) +
':</li>\n\t\t\t\t\t<li><a href="#/users" class="js-select js-no-pjax" data-checked="js-checkbox-list" title="' +
__e( i18next.t('All') ) +
'">' +
__e( i18next.t("All") ) +
'</a></li>\n\t\t\t\t\t<li><a href="#/users" class="js-select js-no-pjax" data-unchecked="js-checkbox-list" title="' +
__e( i18next.t('None') ) +
'">' +
__e( i18next.t("None") ) +
'</a></li>\n\t\t\t\t\t<li><a title="' +
__e( i18next.t('Inactive') ) +
'" href="#/users" class="js-select" data-unchecked="js-checkbox-active" data-checked="js-checkbox-inactive">' +
__e( i18next.t("Closed") ) +
'</a></li>\n\t\t\t\t\t<li><a title="' +
__e( i18next.t('Active') ) +
'" href="#/users" class="js-select" data-unchecked="js-checkbox-inactive" data-checked="js-checkbox-active">' +
__e( i18next.t("Open") ) +
'</a></li>\n\t\t\t\t</ul>\n\t\t\t  <div class="pull-left">\n\t\t\t\t<form class="form-inline" role="form">\n\t\t\t\t  <div class="pr clearfix">\n\t\t\t\t\t\t<select class="js-more-action-user" id="js-more-action">\n\t\t\t\t\t\t  <option value="0">' +
__e( i18next.t("More Actions") ) +
'</option>\n\t\t\t\t\t\t  <option value="1">' +
__e( i18next.t("Close") ) +
'</option>\n\t\t\t\t\t\t  <option value="2">' +
__e( i18next.t("Reopen") ) +
'</option>\n\t\t\t\t\t\t  <option value="3">' +
__e( i18next.t("Delete") ) +
'</option>\n\t\t\t\t\t\t</select>\n\t\t\t\t\t</div>\n\t\t\t\t</form>\n\t\t\t  </div>\n\t\t\t  <div class="pull-right pagination pagination-right pagination-boxes list-group-item-heading"></div>\n        </div>\n\t</section>\n   </div>\n';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/admin_board_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<td>\n    <div class="form-group text-center">\n\t    <div class="checkbox">\n            <input id="' +
__e( board.attributes.id) +
'"  name="board_id[' +
__e( board.attributes.id ) +
']" value="' +
__e( board.attributes.id) +
'" class="js-checkbox-list ';
if(parseInt(board.attributes.is_closed) === 0){;
__p += 'js-checkbox-active';
}else{;
__p += 'js-checkbox-inactive';
};
__p += '" type="checkbox">\n            <label class="js-update-board" data-board_id="' +
__e( board.attributes.id ) +
'" for="' +
__e( board.attributes.id) +
'"></label>\n        </div>\n    </div>\n</td>\n<td>\n\t<div class="row">\n\t\t<div class="pull-left col-sm-10">\n\t\t\t<div class="clearfix">\n\t\t\t';
 
			var style = '';			
			if (board.attributes.background_picture_url) {
				var background_picture_url = board.attributes.background_picture_url.replace("_XXXX.jpg", "_n.jpg");
				style = 'background:url(' + background_picture_url + ') 25% 25%; background-size: cover';
			} else if (board.attributes.background_pattern_url) {
				var background_pattern_url = board.attributes.background_pattern_url.replace("_XXXX.jpg", "_s.jpg");
				style = 'background: transparent url(' + background_pattern_url + ')  repeat scroll 0% 0%;';
			} else if (board.attributes.background_color){
				style = 'background:' + board.attributes.background_color;
			}
			;
__p += '\n\t\t\t<a href="#/board/' +
__e( board.id ) +
'" class="avatar-sm pull-left" title="' +
__e( board.attributes.name ) +
'" ><span class="clearfix cover-image" style="' +
((__t = ( style )) == null ? '' : __t) +
'"></span></a>\n\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "view_board"}))){ ;
__p += '\n\t\t\t\t  <a href="#/board/' +
__e( board.id ) +
'" title="' +
__e( board.attributes.name ) +
'" class="col-xs-10 htruncate left-mar-sm">\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t';
 if(board.attributes.organization_id > 0 && board.attributes.organization_id != null){ 
					var logo_path = "img/default-organization.png"; 
					if (!_.isUndefined(board.attributes.organization_logo_url) && board.attributes.organization_logo_url != null && board.attributes.organization_logo_url != '') {
						logo_path = board.showImage('Organization', board.attributes.organization_id, 'small_thumb' ); 
					};
__p += '\n\t\t\t\t\t\n\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t  ' +
__e( board.attributes.name) +
' \n\t\t\t\t  ';
 if(!_.isEmpty(role_links.where({slug: "view_board"}))){ ;
__p += '\n\t\t\t\t  </a>\n\t\t\t\t  ';
 } ;
__p += '  \n\t\t    </div>\n\t    </div>\n\t\t';
 if(board.attributes.music_name != null){ ;
__p += '\n\t\t\t<div class="col-sm-2"><i class="icon-music text-muted"></i></div>\n\t\t\t';
 } ;
__p += '\n\t</div>\n \n</td>\n\n<td>\n';
 if(!_.isEmpty(board.attributes.organization_name)){ ;
__p += '\n<div class="clearfix"> \n<a href="#/board/' +
__e( board.id ) +
'"" class="small-user pull-left show"><img alt="[Image: Organization]" title="' +
__e(board.attributes.organization_name) +
'" width="16" height="16" src="' +
__e( logo_path ) +
'"></a>\n <a class="col-xs-9 htruncate" title="' +
__e(board.attributes.organization_name) +
'" href="#/board/' +
__e( board.id ) +
'">' +
__e(board.attributes.organization_name) +
'</a></div>\n ';
 }else{;
__p += '\n <a class="col-xs-9 htruncate" title="-">-</a>\n ';
 };
__p += '\n</td> \n<td>\n\t<div class="clearfix">\n\t   <a href="#/user/' +
__e( board.attributes.user_id ) +
'" class="small-user pull-left show" title="' +
__e(board.attributes.full_name) +
' (' +
__e(board.attributes.username) +
')">\n\t   \t\t';
 if(!_.isEmpty(board.attributes.profile_picture_path)){ 
				var profile_picture_path = board.showImage('User', board.attributes.user_id, 'micro_thumb', true);
			;
__p += '\n\t\t\t\t<img class="img-rounded" width="16" height="16" src="' +
((__t = ( profile_picture_path)) == null ? '' : __t) +
'" alt="[Images: ' +
__e( board.attributes.username) +
']" title="' +
__e( board.attributes.username) +
'" />\n\t\t\t';
 }else{ ;
__p += '\n\t\t\t\t<i class="avatar avatar-color-194 avatar-sm img-rounded">' +
__e( board.attributes.initials) +
'</i>\n\t\t\t';
 } ;
__p += ' \n\t   </a>\n\t   <a href="#/user/' +
__e( board.attributes.user_id ) +
'" title="' +
__e(board.attributes.full_name) +
' (' +
__e(board.attributes.username) +
')" class="col-xs-7 htruncate">' +
__e(board.attributes.username) +
'</a>\n\t</div>\n</td>\n<td>\n<div class="clearfix dropdown">\n\t\n\t<a href="javascript:void(0);" data-toggle="dropdown" class="dropdown-toggle show clearfix navbar-btn h4">\n\t\t';
 var i = 1; if(!_.isUndefined(board.admin_board_users)) {;
__p += '\n\t\t\t ';
  
			  var admin_board_users_count = board.admin_board_users.length;
			  _.each(board.admin_board_users, function(admin_board_user){ 
				if(i <= 3){
			  ;
__p += '\n            \t<span class="pull-left btn-xs nav">\n\t\t\t\t\t<span class="col-xs-12 btn-block" title="' +
__e(admin_board_user.full_name ) +
' (' +
__e(admin_board_user.username ) +
')">\n\t\t\t\t\t\t';
 if(!_.isEmpty(admin_board_user.profile_picture_path)) {
								var profile_picture_path = board.showImage('User', admin_board_user.user_id, 'small_thumb' );;
__p += '\n\t\t\t\t\t\t<img  width="30" height="30" class="img-responsive img-rounded avatar" title="' +
__e(admin_board_user.full_name ) +
' (' +
__e(admin_board_user.username ) +
')" alt="[Images: ' +
__e(admin_board_user.full_name ) +
']" src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'">\n\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t<i class="avatar avatar-color-194 img-rounded">' +
((__t = ( (admin_board_user.initials) )) == null ? '' : __t) +
'</i>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t';
 if(!_.isUndefined(board.board_user_roles[admin_board_user.board_user_role_id - 1].id) && parseInt(board.board_user_roles[admin_board_user.board_user_role_id - 1].id) === 1){ ;
__p += '\n\t\t\t\t\t\t\t<span class="name-block col-xs-12 label btn-xs col-xs-push-0">' +
__e( i18next.t("Owner") ) +
'</span>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t</span>\n\t\t\t\t</span>\n\t\t\t  ';
 i++; }}); };
__p += '\n\t\t\t  \n\t\t\t  ';
 
			  if(!_.isUndefined(board.normal_board_users)) {
			  var normal_board_users_count = board.normal_board_users.length;
			  if(admin_board_users_count < 3){ 
			   _.each(board.normal_board_users, function(normal_board_user){
				if(i <= 3){
				var mobHidden='';
				if(i !== 1){
				  mobHidden = 'hidden-xs';
				}
			  ;
__p += '\n            \t<span class="pull-left btn-xs nav ' +
__e( mobHidden ) +
'">\n\t\t\t\t\t<span class="col-xs-12 btn-block" title="' +
__e(normal_board_user.full_name ) +
' (' +
__e(normal_board_user.username ) +
')">\n\t\t\t\t\t\t';
 if(!_.isEmpty(normal_board_user.profile_picture_path)) {
								var profile_picture_path = board.showImage('User', normal_board_user.user_id, 'small_thumb' );;
__p += '\n\t\t\t\t\t\t<img  width="30" height="30" class="img-responsive img-rounded avatar" title="' +
__e(normal_board_user.full_name ) +
' (' +
__e(normal_board_user.username ) +
')" alt="[Images: ' +
__e(normal_board_user.full_name ) +
']" src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'">\n\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t<i class="avatar avatar-color-194 img-rounded">' +
((__t = ( (normal_board_user.initials) )) == null ? '' : __t) +
'</i>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t</span>\n\t\t\t\t</span>\n\t\t\t  ';
 i++; }}); } };
__p += '\n\t\t\t \n\t\t\t  ';
 if(_.isUndefined(board.normal_board_users) && _.isUndefined(board.admin_board_users)) { ;
__p += '-';
 } else {;
__p += ' <span class="col-xs-3 label small hidden-xs"> \n\t\t\t\t<span class="small navbar-btn">\n\t\t\t\t\t<span class="show text-left text-muted" title="' +
__e( i18next.t('Owner %s', { postProcess: 'sprintf', sprintf: [admin_board_users_count]}) ) +
' ">' +
__e( i18next.t('Owner %s', { postProcess: 'sprintf', sprintf: [admin_board_users_count]}) ) +
'</span> \n\t\t\t\t\t<span class="show navbar-btn text-left text-muted" title="' +
__e( i18next.t('Member %s', { postProcess: 'sprintf', sprintf: [normal_board_users_count]}) ) +
' ">' +
__e( i18next.t('Member %s', { postProcess: 'sprintf', sprintf: [normal_board_users_count]}) ) +
'</span>\n\t\t\t\t\t</span> \n\t\t\t\t</span> ';
 } ;
__p += '</a>\n\t\t\t\t<ul class="list-unstyled js-visibility-chooser dropdown-menu arrow arrow-right">\n\t\t\t\t\t  <li class="text-center">\n\t\t\t\t\t\t<strong>' +
__e( i18next.t("Members") ) +
'</strong>\n\t\t\t\t\t\t<span href="#" class="js-close-popover pull-right col-xs-2"><i class="icon-remove cur"></i></span>\n\t\t\t\t\t  </li>\n\t\t\t\t\t  <li class="divider"></li>\n\t\t\t\t\t  <li class="col-xs-12">\n\t\t\t\t\t\t<ul class="list-unstyled clearfix js-get-board-member-lists-response">\n\t\t\t\t\t\t\t';
 board.board_users.each(function(user) { ;
__p += '\n\t\t\t\t\t\t\t\t<li class="form-inline navbar-btn btn-xs pull-left js-board-user-avatar-click dropdown nav">\n\t\t\t\t\t\t\t\t\t\t<a href="#/user/' +
__e(user.attributes.id ) +
'">\n\t\t\t\t\t\t\t\t\t\t<span data-placement="bottom" title="' +
__e( user.attributes.full_name ) +
' (' +
__e(user.attributes.username ) +
')" data-toggle="tooltip" class="col-xs-12 btn-block navbar-btn">\t\t\t\t\n\t\t\t\t\t\t\t\t\t\t';
 if(!_.isEmpty(user.attributes.profile_picture_path)) { 
											var profile_picture_path = board.showImage('User', user.attributes.user_id, 'small_thumb' );
										;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t<img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(user.attributes.full_name ) +
']" title="' +
__e(user.attributes.full_name ) +
' (' +
__e(user.attributes.username ) +
')" class="img-rounded img-responsive avatar">\n\t\t\t\t\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t<i class="avatar avatar-color-194 img-rounded">' +
__e( user.attributes.initials ) +
'</i>\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t\t';
 if(!_.isUndefined(board.board_user_roles[user.attributes.board_user_role_id - 1].id) && parseInt(board.board_user_roles[user.attributes.board_user_role_id - 1].id) === 1){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t<span class="name-block col-xs-1 label btn-xs col-xs-push-0">' +
__e( i18next.t("Owner") ) +
'</span>\n\t\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t</span>\n\t\t\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t';
 }); ;
__p += '\t\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t</li>\n\t\t\t\t\t</ul>\n\t\t\t  </div>\n</td>\n \n<td class="text-center">\n\t' +
__e( board.attributes.list_count) +
'\n</td>\n<td class="text-center">\n\t' +
__e( board.attributes.archived_list_count) +
'\n</td>\n<td class="text-center"> \n\t' +
__e( board.attributes.card_count) +
' \n</td> \n<td class="text-center"> \n\t' +
__e( board.attributes.archived_card_count) +
' \n</td> \n<td class="text-center">\n    <a href="#" class="js-no-action"><abbr class="timeago" title="' +
__e(board.attributes.created) +
'">' +
__e(board.attributes.created) +
'</abbr></a>\n</td>\n<td class="text-center">\n    <a href="#" class="js-no-action"><abbr class="timeago" title="' +
__e(board.attributes.modified) +
'">' +
__e(board.attributes.modified) +
'</abbr></a>\n</td>\n<td class="text-center">\n    <div class="btn-group navbar-btn js-visibility-list-dropdown dropdown">\n        ';
 	var board_visibility = '';
		    var board_visibility_icon = '';
			if(board.attributes.board_visibility == 0) { 
					board_visibility = 'Private';
					board_visibility_icon = 'icon-lock';
				} else if(board.attributes.board_visibility == 1 && board.attributes.organization_id > 0) {
					board_visibility = 'Organization';
					board_visibility_icon = 'icon-group';
				} else if(board.attributes.board_visibility == 2) {
					board_visibility = 'Public';
					board_visibility_icon = 'icon-circle';
				}
			;
__p += '\n\t\t\t<button class="btn btn-default btn-sm js-board-visibility" type="button"><i class="' +
__e( board_visibility_icon) +
'"></i><span class="hidden-xs">' +
((__t = ( i18next.t(board_visibility) )) == null ? '' : __t) +
'</span></button>\n\t\t\t\n\t\t\t<button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle active js-board-visibility" type="button"> <span><i class="icon-caret-down cur"></i></span> <span class="sr-only">' +
__e( i18next.t("Toggle Dropdown") ) +
'</span> </button>\n\t\t\t\n\t\t\t<ul class="dropdown-menu arrow arrow-right col-xs-push-0 pre-scrollable vertical-scrollbar">\n\t\t\t\t<li class="js-visibility-popup js-dropdown-popup dropdown-popup col-xs-12">          \n\t\t\t\t\t<div class="clearfix text-center"><a class="js-back-to-board-visibility hide pull-left" href="#"><i class="icon-caret-left"></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t("Change Visibility") ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\n\t\t\t\t\t</div>\n\t\t\t\t</li>\n\t\t\t\t<li class="col-xs-12 divider js-visibility-list"></li>\n\t\t\t</ul>\n\t</div>\n\t             \n</td>';

}
return __p
};

this["JST"]["templates/admin_user_add"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 col-lg-offset-4 col-md-offset-4 col-sm-offset-3">\n<div class="panel panel-default">\n  <div class="panel-heading lead">' +
__e( i18next.t("Add User") ) +
'</div>\n  <div class="panel-body well-lg">\n\t<form id="AdminUserAddForm" name="AdminUserAddForm" class="form-horizontal col-xs-12">\n\t  <div class="form-group required">\n\t\t<label class="sr-only control-label" for="inputEmail">' +
__e( i18next.t("Email") ) +
'</label>\n\t\t<input type="email" required name="email" id="inputEmail" class="form-control" placeholder="' +
__e( i18next.t('Email') ) +
'" title="' +
__e( i18next.t('Email') ) +
'">\n\t  </div>\n\t  <div class="form-group required">\n\t\t<label class="sr-only control-label" for="inputUsername">' +
__e( i18next.t("Username") ) +
'</label>\n\t\t<input type="name" name="username" id="inputUsername" class="form-control" placeholder="' +
__e( i18next.t('Username') ) +
'" required pattern=".{3,15}" title="' +
__e( i18next.t('Username. Minimum 3 characters') ) +
'">\n\t  </div>\n\t  <div class="form-group required">\n\t\t<label class="sr-only control-label" for="inputPassword">' +
__e( i18next.t("Password") ) +
'</label>\n\t\t<input type="password" required name="password" id="inputPassword"class="form-control" placeholder="' +
__e( i18next.t('Password') ) +
'" pattern="[A-Za-z0-9\\S]{6,50}" title="' +
__e( i18next.t('Password. Minimum 6 characters and white space not allowed') ) +
'">\n\t  </div>\n\t  <div class="form-group">\n\t\t<label class="sr-only control-label" for="submitAddUser">' +
__e( i18next.t("Join Now") ) +
'</label>\n\t\t<input type="submit" class="btn btn-primary col-xs-12" id="submitAddUser" value="' +
__e( i18next.t('Add') ) +
'">\n\t  </div>\n\t</form>\n  </div>\n</div>\n</div>';

}
return __p
};

this["JST"]["templates/app"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="well-lg navbar-btn"></div>\n';

	if (apps.length > 0 ) { 
		_.each(apps, function(app) {
;
__p += '\n\t<div class="clearfix">\n\t\t<div class="col-xs-1">\n\t\t\t<div class="pull-left"><img width="80" height="80" src="' +
__e( app.icon ) +
'"></div>\n\t\t</div>\n\t\t<div class="col-xs-9">\n\t\t\t<h4><span class="c">' +
__e( i18next.t(app.name) ) +
'</span></h4>\n\t\t\t<div class="grayc top-space">' +
__e( i18next.t(app.description) ) +
'</div>\n\t\t\t<div class="grayc top-space">' +
__e( i18next.t('Version') ) +
' ' +
__e( app.version ) +
' | ' +
__e( i18next.t('By') ) +
' <a href="' +
__e( app.authorUrl ) +
'" target="_blank">' +
__e( app.author ) +
'</a></div>\n\t\t</div>\n\t\t<div class="col-xs-2 pull-right">\n\t\t\t<div class="row-fluid">\n\t\t\t\t<div class="pull-right">\n\t\t\t\t\t<div class="btn-group">\n\t\t\t\t\t\t<button class="btn ">';
 if(app.enabled == true){ ;
__p +=
__e( i18next.t('Enabled') );
 } else {;
__p +=
__e( i18next.t('Disabled') );
 } ;
__p += '</button>\n\t\t\t\t\t\t<button class="btn dropdown-toggle js-no-pjax xltriggered" data-toggle="dropdown"><i class="icon-cog"></i><span class="caret"></span></button>\n\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right pull-right">\n\t\t\t\t\t\t\t<li><a class="cur js-update-app" data-current-status="' +
__e( app.enabled ) +
'" data-folder="' +
__e( app.folder ) +
'" title="';
 if(app.enabled == true){ ;
__p +=
__e( i18next.t('Disabled') );
 } else {;
__p +=
__e( i18next.t('Enabled') );
 } ;
__p += '"><i class="';
 if(app.enabled == true){ ;
__p += 'icon-minus-sign';
 } else {;
__p += 'icon-plus-sign';
 } ;
__p += '"></i>';
 if(app.enabled == true){ ;
__p +=
__e( i18next.t('Disabled') );
 } else {;
__p +=
__e( i18next.t('Enabled') );
 } ;
__p += '</a></li>\n\t\t\t\t\t\t\t';
 if(app.settings){;
__p += '\n\t\t\t\t\t\t\t\t<li><a title="' +
__e( i18next.t('Settings') ) +
'" href="#/apps/' +
__e( app.folder ) +
'"><i class="icon-cog"></i>' +
__e( i18next.t('Settings') ) +
'</a></li>\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t</div>\n\t<hr/>\n';

		}); 
	}
;


}
return __p
};

this["JST"]["templates/app_setting"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="well-sm">\n\t<h3>' +
__e( i18next.t(app_settings[0].app_name) ) +
' - ' +
__e( i18next.t('Settings') ) +
'</h3>\n</div>\n<div class="alert alert-info list-group-item-text">' +
((__t = ( i18next.t(app_settings[0].settings_description) )) == null ? '' : __t) +
'</div>\n<div class="well-sm"></div>\n<form class="js-app-setting-form" role="form" id="js-app-setting-form">\n';
 if (app_settings.length > 0 ) { 
var folder = '';
_.each(app_settings, function(app_setting) { 
	folder = app_setting.folder;
;
__p += '\n\t<div class="form-group col-xs-12">\n\t\t\t  <label class="col-sm-2  control-label col-xs-12">' +
__e( i18next.t(app_setting.label ) ) +
'</label>\n\t\t\t  <div class=" col-sm-7  col-xs-12">\n\t\t\t\t<input type="text" value="' +
__e( app_setting.value ) +
'" class="form-control" name="' +
__e( app_setting.name ) +
'" id="' +
__e( app_setting.name ) +
'">\n\t\t\t\t<div><span class="help-block">' +
__e( app_setting.info ) +
'</span></div>\n\t\t\t  </div>\n\t</div>\n\n';
 }); 
} ;
__p += '\n<input type="hidden" value="' +
__e( folder ) +
'" name="folder" id="folder">\n  <div class="form-group">\n\t<label for="submit" class="sr-only  col-sm-4  control-label col-xs-12">' +
__e( i18next.t('Submit') ) +
'</label>\n\t<div class="col-xs-offset-2">\n\t<input type="submit" value="' +
__e( i18next.t('Update') ) +
'" id="submit" class="btn btn-primary">\n\t</div>\n  </div>\n</form>';

}
return __p
};

this["JST"]["templates/archive_card_delete_confirm"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\t\n\t<a href="#" class="js-archived-items pull-left" data-list-id="' +
__e( list.id ) +
'"><i class="icon-caret-left "></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t("Delete All Card") ) +
'</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove "></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<p>' +
__e( i18next.t("There is no undo. This will remove All Archive Cards and destroy its history.") ) +
'</p>\t\n\t<a class="js-delete-all-archived-cards-delete btn  btn-primary" title="' +
__e( i18next.t('Delete All Card') ) +
'" data-list-id="' +
__e( list.id ) +
'">' +
__e( i18next.t("Delete") ) +
'</a>\n</div>';

}
return __p
};

this["JST"]["templates/archive_list_delete_confirm"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\t\n\t<a href="#" class="js-archived-items pull-left" data-list-id="' +
__e( list.id ) +
'"><i class="icon-caret-left "></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t("Delete All List") ) +
'</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove "></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<p>' +
__e( i18next.t("There is no undo. This will remove All Archive Lists and destroy its history.") ) +
'</p>\t\n\t<a class="js-delete-all-archived-list-delete btn  btn-primary" title="' +
__e( i18next.t('Delete All List') ) +
'" data-list-id="' +
__e( list.id ) +
'">' +
__e( i18next.t("Delete") ) +
'</a>\n</div>';

}
return __p
};

this["JST"]["templates/archived_card"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(card != null){ if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.acl_links.where({slug: "view_archived_cards",board_user_role_id: parseInt(card.board_user_role_id)})))){ ;
__p += '\n<a href="#/card/' +
__e( card.attributes.id) +
'" class="highlight-icon pull-left">' +
__e(card.attributes.name) +
'</a><div class="pull-right">';
 if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.acl_links.where({slug: 'send_back_to_archived_card', board_user_role_id: parseInt(card.board_user_role_id)})))) {;
__p += '<a title="' +
__e( i18next.t('Send to board') ) +
'" class="js-send-card-to-board ';
 if (!_.isEmpty(role_links.where({slug: 'add_organization'}))) {;
__p += 'send_back_to_archived_card ';
};
__p += '" data-card_id="' +
__e(card.attributes.id) +
'"><i class="icon-reply"></i></a>';
};

 if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.acl_links.where({slug: 'delete_all_archived_cards', board_user_role_id: parseInt(card.board_user_role_id)})))) {;
__p += '<a class="js-delete-archived-card" data-card_id="' +
__e(card.attributes.id) +
'" title="' +
__e( i18next.t('Delete') ) +
'"><i class="icon-remove btn btn-link"></i></a>';
};
__p += '</div>\n';
 }}else{ ;
__p += '\n<span class="alert alert-info">\n\t' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('cards')] }) ) +
'\n</span>\n';
};
__p += '\n';

}
return __p
};

this["JST"]["templates/archived_cards"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<form class="form-horizontal"><div class="form-group"><input class="js-search-archived-cards form-control" id="inputSearchArchivedCards" name="name"></div></form><div class="row navbar-btn"><a href="#" class="js-show-archived-lists">' +
__e( i18next.t("Switch to lists") ) +
'</a>';
 if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: 'delete_all_archived_cards', board_user_role_id: parseInt(board.board_user_role_id)})))) {;
__p += '<button  href="#" class="js-delete-all-archived-cards btn btn-primary pull-right">' +
__e( i18next.t("Delete All") ) +
'</button>';
 } ;
__p += '</div><div class="row"><ul class="sidebar-boards-list list-unstyled  js-archived-cards-container"></ul></div>';

}
return __p
};

this["JST"]["templates/archived_items"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<ul class="list-unstyled"><li><div class="clearfix text-center col-xs-12"><a href="#" class="js-back-to-sidebar pull-left btn btn-xs btn-link"><i class="icon-caret-left"></i></a> <span class="col-xs-10 navbar-btn"><strong>' +
__e( i18next.t("Archived Items") ) +
'</strong></span></div><div class="col-xs-12 divider"></div><div class="col-xs-12 member-modal js-pre-scrollable vertical-scrollbar js-archived-items-container"></div></li></ul>';

}
return __p
};

this["JST"]["templates/archived_list"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(list != null){ if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(list.board.acl_links.where({slug: "view_archived_lists",board_user_role_id: parseInt(list.board.board_user_role_id)})))) { ;
__p += '\n<span class="highlight-icon pull-left">' +
__e( list.attributes.name ) +
'</span><div class="pull-right">';
 if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(list.board.acl_links.where({slug: 'send_back_to_archived_list', board_user_role_id: parseInt(list.board.board_user_role_id)})))) {;
__p += '<a title="' +
__e( i18next.t('Send to board') ) +
'" class="js-send-list-to-board" data-list_id="' +
__e( list.attributes.id ) +
'"><i class="icon-reply"></i></a>';
};

 if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(list.board.acl_links.where({slug: 'delete_all_archived_lists', board_user_role_id: parseInt(list.board.board_user_role_id)})))) {;
__p += '<a title="' +
__e( i18next.t('Delete') ) +
'" class="js-delete-archived-list" data-list_id="' +
__e( list.attributes.id ) +
'"><i class="icon-remove btn btn-link"></i></a>';
};
__p += '</div>\n';
 }}else{ ;
__p += '\n<span class="alert alert-info">\n\t' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('lists')] }) ) +
'\n</span>\n';
};


}
return __p
};

this["JST"]["templates/archived_lists"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<form class="form-horizontal"><div class="form-group"><input class="js-search-archived-lists form-control" id="inputSearchArchivedLists" name="name"></div></form><div class="row navbar-btn"><a href="#" class="js-show-archived-card-lists">' +
__e( i18next.t("Switch to Cards") ) +
'</a>';
 if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: 'delete_all_archived_lists', board_user_role_id: parseInt(board.board_user_role_id)})))) {;
__p += '<button href="#" class="js-delete-all-archived-lists-confirm btn btn-primary pull-right">' +
__e( i18next.t("Delete All") ) +
'</button>';
 } ;
__p += '</div><div class="row"><ul class="sidebar-boards-list list-unstyled js-archived-cards-container"></ul></div>';

}
return __p
};

this["JST"]["templates/attachment"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(attachment != null){ ;
__p += ' \n\t<a target="_blank" href="' +
((__t = ( attachment.downloadLink('download', attachment.get('id')) )) == null ? '' : __t) +
'?view" class="pull-left navbar-btn img-thumbnail thumb-img">\n\t\t';
 if(attachment.get("name").match(/\.(jpg|jpeg|png|gif)$/)){ 
			var picture_path = attachment.showImage('CardAttachment', attachment.attributes.id, 'large_thumb' );
		;
__p += '\n\t\t\t<img src="' +
((__t = ( picture_path)) == null ? '' : __t) +
'" class="img-responsive center-block">\n\t\t';
 } else{ 
			 var extension = attachment.attributes.name.split('.');
		;
__p += '\n\t\t\t<p class="thumb-img"><span class="h1 navbar-btn">';
 if(!_.isUndefined(extension) && extension.length > 1) { ;
__p +=
__e( extension[extension.length - 1].toUpperCase() );
 };
__p += '</span></p>\n\t\t';
 };
__p += '\n\t</a>\n\t<div class="clearfix btn-block col-xs-12">\n\t\t<a target="_blank" class="htruncate col-xs-12 btn-block" href="' +
((__t = ( attachment.downloadLink('download', attachment.get('id')) )) == null ? '' : __t) +
'" title="' +
__e( attachment.get('name') ) +
'">' +
__e( attachment.get('name') ) +
'\n\t\t<span class="show">' +
__e( i18next.t("Added") ) +
' <small class="text-muted"><abbr class="timeago" title="' +
__e( attachment.get('created') ) +
'">' +
__e( attachment.get("created") ) +
'</abbr></small></span>\n\t\t</a> \n\t\t';
if(!_.isUndefined(authuser.user)) {;
__p += '\n\t\t<div class="btn-toolbar navbar-btn">\n\t\t\t<div class="btn-group btn-group-xs navbar-btn">\n\t\t\t\t<div class="btn btn-primary">\n\t\t\t\t';
 var download_link = attachment.downloadLink('download', attachment.get('id')); ;
__p += '\n\t\t\t\t\t<a target="_blank" href="' +
((__t = ( download_link )) == null ? '' : __t) +
'" title="' +
__e( i18next.t('Download') ) +
'">\n\t\t\t\t\t\t<i class="icon-arrow-down cur icon-light"></i>\n\t\t\t\t\t</a>\n\t\t\t\t</div>\n\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "remove_card_attachment", board_user_role_id: parseInt(board.board_user_role_id)})))) { ;
__p += ' \n\t\t\t\t\t<div class="dropdown dropdown pull-left">\n\t\t\t\t\t\t<a href="#" title="Delete" class="js-show-confirm-delete-attachment dropdown-toggle btn btn-default btn-xs" data-toggle="dropdown"><i class="icon-remove cur"></i></a>\n\t\t\t\t\t\t<ul class="dropdown-menu arrow list-unstyled">\n\t\t\t\t\t\t\t<li class="js-dropdown-popup js-attachment-confirm-respons-' +
__e( attachment.id ) +
'"></li>\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t</div>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t</div>\n\t\t</div>\n\t\t';
 } ;
__p += '\n\t</div>\n';
 }else{ ;
__p += ' \n\t<span class="alert alert-info">' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('attachments')] }) ) +
'</span>\n';
 } ;
__p += ' ';

}
return __p
};

this["JST"]["templates/attachment_delete_confirm"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12"><span class="col-xs-10"><strong>' +
__e( i18next.t("Delete Attachment") ) +
'?</strong></span><a class="js-span-close-popup pull-right" href="#"><i class="icon-remove"></i></a></div><div class="col-xs-12 divider"></div><div class="col-xs-12"><p>' +
__e( i18next.t("Deleting an attachment is permanent. There is no undo.") ) +
'</p><a class="js-delete-attachment btn btn-primary" title="' +
__e( i18next.t('Delete Attachment') ) +
'">' +
__e( i18next.t("Delete") ) +
'</a></div>';

}
return __p
};

this["JST"]["templates/attachment_delete_confirm_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12"><span class="col-xs-10"><strong>' +
__e( i18next.t("Delete Attachment") ) +
'? </strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove"></i></a></div><div class="col-xs-12 divider"></div><div class="col-xs-12"><p>' +
__e( i18next.t("Deleting an attachment is permanent. There is no undo.") ) +
'</p><a class="js-delete-attachment btn btn-primary" title="' +
__e( i18next.t('Delete Attachment') ) +
'">' +
__e( i18next.t("Delete") ) +
'</a></div>';

}
return __p
};

this["JST"]["templates/board"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 
	if(board.attributes.is_closed) {
		var style = '';
	if (board.attributes.background_picture_url || board.attributes.background_pattern_url || board.attributes.background_color) {
		style = 'color:#ffffff;';
	}
;
__p += '\n<div class="well-lg navbar-btn">&nbsp;</div>\n<div class="board-close-view">\n  <strong>' +
__e( i18next.t("Board is closed") ) +
'</strong>\n  ';
 if(!_.isUndefined(authuser.user)) { ;
__p += '\n  <div class="dropdown well-sm text-center"><a data-toggle="dropdown" class="dropdown-toggle btn btn-primary" href="#">' +
__e( i18next.t("Click here to Reopen Board") ) +
'</a>\n        <ul class="dropdown-menu">\n      <li class="js-visibility-popup js-dropdown-popup dropdown-popup">\n        <div class="clearfix text-center col-xs-12">\n          <span class="col-xs-10"><strong>' +
__e( i18next.t("Reopen Board") ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\n        </div>\n\t\t<div class="col-xs-12 divider"></div>\n        <div class="col-xs-12  text-left">\n          <form class="normal" name="BoardReopenForm" id="BoardReopenForm">\n            <input id="inputBoardClose" name="is_closed" type="hidden" value="false">\n            <div class="h6 btn-block">' +
__e( i18next.t('Are you sure you want to do this action') ) +
'?</div>\n            <div class="submit">\n              <input type="submit" value="' +
__e( i18next.t('Reopen') ) +
'" id="submitBoardReopen" class="btn btn-primary btn-sm">\n            </div>\n          </form>\n        </div>\n      </li>\n    </ul>\n  </div>\n  ';
 } ;
__p += '\n  </div>\n  ';
 } else {;
__p += '\n  <section class="row body-no-webkit-scrollbars">\n\t\t<div id="switch-board-view" class="clearfix js-board-view-' +
__e( board.id) +
'">\n\t\t\t<div id="js-board-lists" class="board-list-view boardlist-scrollbar">\n\t\t\t';

			if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({
				slug: 'add_list',
				board_user_role_id: parseInt(board.board_user_role_id)
			})))){ ;
__p += '\n\t\t\t  <div class="col-lg-3 col-md-3 col-sm-4 col-xs-12 btn-block list" id="js-add-list-block">\n\t\t\t\t<div class="js-list-form"><a href="#" class="js-show-add-list-form toggle-show text-muted" title="' +
__e( i18next.t('Add a list') ) +
'">' +
__e( i18next.t('Add a list') ) +
'</a>\n\t\t\t\t  <form class="js-add-list hide">\n\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t  <label for="\n\t\t\t\t\t  inputListName" class="sr-only">' +
__e( i18next.t('Name') ) +
'</label>\n\t\t\t\t\t  <input type="text" id="inputListName" autocomplete="off" name="name" class="form-control" placeholder="' +
__e( i18next.t('Add a list') ) +
'" required maxlength="255" title="' +
__e( i18next.t('Whitespace alone not allowed') ) +
'" required pattern=".*\\S+.*">\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t  <input type="submit" name="Save" class="btn btn-primary" value="' +
__e( i18next.t('Save') ) +
'">\n\t\t\t\t\t  <i class="icon-remove js-hide-add-list-form btn btn-link cur" title="' +
__e( i18next.t('Cancel') ) +
'"></i></div>\n\t\t\t\t  </form>\n\t\t\t\t</div>\n\t\t\t  </div>\n\t\t\t  ';
 } ;
__p += '\n\t\t </div>          \n\t  </div>          \n  </section>\n  ';
 } ;


}
return __p
};

this["JST"]["templates/board_404"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="well-lg navbar-btn">&nbsp;</div>\n<div class="board-close-view">\n  <strong>' +
__e( i18next.t("Board not found") ) +
'</strong>\n  <div class="well-sm">' +
__e( i18next.t("This board may be private.") ) +
' ';
 if(!_.isEmpty(role_links.where({slug: "users_login"})) && _.isUndefined(authuser.user)){ ;
__p +=
((__t = ( i18next.t("You may be able to view it by %s", {postProcess: 'sprintf', sprintf: ['<a href="#/users/login" class="text-primary" title="'+ i18next.t('Login') +'">'+ i18next.t('logging in.') +'</a>']}) )) == null ? '' : __t) +
' ';
 } ;
__p += '\n  </div>\n  </div>';

}
return __p
};

this["JST"]["templates/board_add"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li>\n\t<div class="col-xs-12 text-center clearfix">\n\t\t<a href="#" class="js-show-organizations-board-from pull-left"><i class="icon-caret-left"></i></a>\n\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t("Create Board") ) +
'</strong></span>\n\t\t<a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\n\t</div>\n</li>\n<li class="col-xs-12 divider"></li>\n<li>\n\t<form class="col-xs-12" name="BoardAddForm" id="BoardAddForm">\n\t\t<div class="form-group">\n\t\t\t<label for="inputBoardName">' +
__e( i18next.t("Name") ) +
'</label>\n\t\t\t<input class="form-control input-sm" type="text" id="inputBoardName" name="name" title="' +
__e( i18next.t('Whitespace alone not allowed') ) +
'" required pattern=".*\\S+.*">\n\t\t</div>\n\t\t';
 if (templates.models.length > 0 && !_.isEmpty(role_links.where({slug: "view_organization_visibility"}))) { ;
__p += '\n\t\t\t<div class="form-group">\n\t\t\t\t<label for="inputchecklist">' +
__e( i18next.t("Template") ) +
'</label>\n\t\t\t\t<select id="inputtemplatelist" class="js-chosen-select" name="template">\n\t\t\t\t\t<option value="">' +
__e( i18next.t("Select Template") ) +
'</option>\n\t\t\t\t\t';
 _.each(templates.models, function(template) { ;
__p += '\n\t\t\t\t\t<option value="' +
((__t = ( template.get('value') )) == null ? '' : __t) +
'">' +
__e( template.get('name') ) +
'</option>\n\t\t\t\t\t';
 });;
__p += '\n\t\t\t\t</select></div>';
 } ;
__p += '\n\t\t\t\t<div id="js-board-add-organization"></div>\n\t\t\t\t<input id="inputBoardAddVisibility" name="board_visibility" type="hidden" value="0">\n\t\t\t\t<div class="clearfix js-open-dropdown js-board-add-dropdown board-add-dropdown dropdown"> \n\t\t\t\t\t<span class="js-visibility-container">\n\t\t\t\t\t\t<span class="pull-left">\n\t\t\t\t\t\t\t<span class="pull-left navbar-btn">' +
__e( i18next.t("This board will be") ) +
' </span>\n\t\t\t\t\t\t</span>\n\t\t\t\t\t\t<div class="btn-group pull-right">\n\t\t\t\t\t\t\t<button type="button" class="btn btn-default btn-sm js-change-visibility"><i class="icon-lock"></i>' +
__e( i18next.t("Private") ) +
'</button>\n\t\t\t\t\t\t\t<button type="button" class="btn btn-default btn-sm dropdown-toggle js-change-visibility" data-toggle="dropdown" aria-expanded="false">\n\t\t\t\t\t\t\t\t<span><i class="icon-caret-down"></i></span>\n\t\t\t\t\t\t\t\t<span class="sr-only">' +
__e( i18next.t("Toggle Dropdown") ) +
'</span>\n\t\t\t\t\t\t\t</button>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</span>\n\t\t\t\t\t<div class="js-visibility-chooser dropdown-menu"></div>\n\t\t\t\t</div>\n\t\t\t\t\t<div class="submit"><input type="submit" value="' +
__e( i18next.t('Add') ) +
'" id="submitBoardAdd" class="btn btn-primary"></div></form></li>';

}
return __p
};

this["JST"]["templates/board_add_organization_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<label for="inputchecklist">' +
__e( i18next.t("Organization") ) +
'</label>\n';
 var organization_options = ''; _.each(organizations.models, function(organization) { organization_options += '<option value="' + organization.id + '">' + _.escape(organization.attributes.name) + '</option>'; }); ;
__p += '<select class="form-control cur" name="organization_id" id="inputListOrganization" required>';
 if (!_.isEmpty(organizations.models)) {;
__p += '<option value="">' +
__e( i18next.t("Please Select") ) +
'</option>' +
((__t = (organization_options )) == null ? '' : __t);
}else{;
__p += '<option value="">' +
__e( i18next.t("(none)") ) +
'</option>';
};
__p += '</select>';

}
return __p
};

this["JST"]["templates/board_additional_settings"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="clearfix text-center col-xs-12"><a href="#" class="js-back-to-sidebar pull-left btn btn-xs btn-link"><i class="icon-caret-left"></i></a><span class="col-xs-10 navbar-btn"><strong>' +
__e( i18next.t("Additional Settings") ) +
'</strong></span></div><div class="col-xs-12 divider"></div><ul class="list-unstyled well-sm col-xs-12 js-board-dues"><li class="js-enable-covers js-AdditionalSettings-enabled ';
 if(!board.attributes.is_show_image_front_of_card) { ;
__p += ' hide ';
 } ;
__p += '"><div class="cur list-group-item well-sm">' +
__e( i18next.t("Card Cover Images Enabled") ) +
' <i class="icon-ok"></i></div></li><li class="clearfix js-enable-covers js-AdditionalSettings-enable list-group-item cur ';
 if(board.attributes.is_show_image_front_of_card) { ;
__p += ' hide ';
 } ;
__p += '">' +
__e( i18next.t("Enable Card Cover Images") ) +
'</li></ul>';

}
return __p
};

this["JST"]["templates/board_background"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\n  <a href="#" class="js-back-to-sidebar pull-left btn btn-xs btn-link"><i class="icon-caret-left"></i></a><span class="col-xs-10 navbar-btn"><strong>' +
__e( i18next.t("Change Background") ) +
'</strong></span>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12 member-modal js-pre-scrollable vertical-scrollbar clearfix">\n  <ul class="list-inline col-xs-offset-0">\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#34495e"><span class="background-box show well-lg" style="background-color:#34495e"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#23719f"><span class="background-box show well-lg" style="background-color:#23719f"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#5a966e"><span class="background-box show well-lg" style="background-color:#5a966e"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#bf4a40"><span class="background-box show well-lg" style="background-color:#bf4a40"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#5f778e"><span class="background-box show well-lg" style="background-color:#5f778e"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#0091ff"><span class="background-box show well-lg" style="background-color:#0091ff"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#46ba97"><span class="background-box show well-lg" style="background-color:#46ba97"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#f47564"><span class="background-box show well-lg" style="background-color:#f47564"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#819da2"><span class="background-box show well-lg" style="background-color:#819da2"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#47b7cd"><span class="background-box show well-lg" style="background-color:#47b7cd"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#95d9ad"><span class="background-box show well-lg" style="background-color:#95d9ad"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#f7b09c"><span class="background-box show well-lg" style="background-color:#f7b09c"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#b3bec1"><span class="background-box show well-lg" style="background-color:#b3bec1"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#bee5f3"><span class="background-box show well-lg" style="background-color:#bee5f3"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#caefd2"><span class="background-box show well-lg" style="background-color:#caefd2"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#f7d2c8"><span class="background-box show well-lg" style="background-color:#f7d2c8"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#444444"><span class="background-box show well-lg" style="background-color:#444444"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#4f4d7e"><span class="background-box show well-lg" style="background-color:#4f4d7e"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#2f663c"><span class="background-box show well-lg" style="background-color:#2f663c"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#a37e58"><span class="background-box show well-lg" style="background-color:#a37e58"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#6b6b6b"><span class="background-box show well-lg" style="background-color:#6b6b6b"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#7b5cb3"><span class="background-box show well-lg" style="background-color:#7b5cb3"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#65ab36"><span class="background-box show well-lg" style="background-color:#65ab36"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#bd6f32"><span class="background-box show well-lg" style="background-color:#bd6f32"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#999999"><span class="background-box show well-lg" style="background-color:#999999"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#baa1e6"><span class="background-box show well-lg" style="background-color:#baa1e6"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#9dbb1d"><span class="background-box show well-lg" style="background-color:#9dbb1d"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#ffce54"><span class="background-box show well-lg" style="background-color:#ffce54"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#d5d5d5"><span class="background-box show well-lg" style="background-color:#d5d5d5"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#dbcff1"><span class="background-box show well-lg" style="background-color:#dbcff1"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#ccdc87"><span class="background-box show well-lg" style="background-color:#ccdc87"></span></li>\n    <li class="list-inline js-change-color board-background-select navbar-btn cur" data-color="#f1eabf"><span class="background-box show well-lg" style="background-color:#f1eabf"></span></li>\n  </ul>\n  <h4>' +
__e( i18next.t("Photos") ) +
'</h4>\n  ';
 if (!_.isEmpty(board.attributes.background_picture_url) && board.attributes.background_picture_url != 'NULL') {
	   var background_picture_url = (board.attributes.background_picture_url).replace("_XXXX.jpg", "_s.jpg"); 
  ;
__p += '\n\t  <ul class="list-inline col-xs-offset-0 clearfix">\n\t\t<li class="list-inline board-background-select navbar-btn cur col-xs-12">\n\n\t\t<ul class="list-inline clearfix">\n\t\t<li class="pull-left">\n\t\t\t<span class="background-box show well-lg" style="background-image:url(' +
((__t = ( background_picture_url )) == null ? '' : __t) +
'); background-size:cover;"></span>\n\t\t</li>\n\t\t<li class="pull-left col-xs-8">\n\t\t\t<div class="clearfix">\n\t\t\t\t<p class="col-xs-5 nav htruncate">\n\t\t\t\t';
 if (!_.isEmpty(board.attributes.background_name) && board.attributes.background_name != 'NULL') { ;
__p += '\n\t\t\t\t\t' +
((__t = ( board.attributes.background_name )) == null ? '' : __t) +
' \n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t</p>\n\t\t\t\t<div class="pull-right">\n\t\t\t\t\t<div class="btn-group btn-group-xs navbar-btn">\n\t\t\t\t\t\t<a class="btn btn-primary js-modal-fliker-trigger" title="' +
__e( i18next.t('Change') ) +
'" href="#" data-type="image" data-toggle="modal" data-target="#modalFlickrPhoto">' +
__e( i18next.t("Change") ) +
'</a>\n\t\t\t\t\t\t<div class="dropdown btn btn-default">\n\t\t\t\t\t\t\t<a data-toggle="dropdown" class="dropdown-toggle" title="' +
__e( i18next.t('Delete') ) +
'" href="#">\n\t\t\t\t\t\t\t\t<i class="icon-remove cur js-delete-background-img"></i>\n\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right list-unstyled">\n\t\t\t\t\t\t\t\t<li id="js-attachment-confirm-respons-22" class="js-dropdown-popup">\n\t\t\t\t\t\t\t\t  <div>\n\t\t\t\t\t\t\t\t\t<div class="clearfix text-center col-xs-12"><span class="col-xs-10"><strong>' +
__e( i18next.t("Delete Attachment") ) +
'?</strong></span><a href="#" class="js-span-close-popup pull-right"><i class="icon-remove"></i></a></div>\n\t\t\t\t\t\t\t\t\t<div class="col-xs-12 divider"></div>\n\t\t\t\t\t\t\t\t\t<div class="col-xs-12 text-left">\n\t\t\t\t\t\t\t\t\t  <p>' +
__e( i18next.t("Deleting an background photo. There is no undo.") ) +
'</p>\n\t\t\t\t\t\t\t\t\t  <a title="' +
__e( i18next.t('Delete background photo') ) +
'" class="btn btn-primary btn-large">' +
__e( i18next.t("Delete") ) +
'</a></div>\n\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div>\n\t\t\t\t<small class="navbar-btn">' +
__e( i18next.t("Powered by") ) +
' <a href="javascript:void(0);" title="' +
__e( i18next.t('Flickr') ) +
'"><strong class="text-primary">' +
__e( i18next.t("Flickr") ) +
'</strong></a></small>\n\t\t\t</div>\t\t\n\t\t</li>\n\t\t</ul>\t\n\t\t\n\t\t\n\t\t</li>\n\t  </ul>\n  ';
 } else { ;
__p += '\n\t <a href="#" class="js-modal-fliker-trigger"  data-type="image" data-toggle="modal" data-target="#modalFlickrPhoto">' +
__e( i18next.t("Choose...") ) +
'</a>\n  ';
 } ;
__p += '  \n\n  <h4>' +
__e( i18next.t("Patterns and Textures") ) +
'</h4>\n  ';
 if (!_.isEmpty(board.attributes.background_pattern_url) && board.attributes.background_pattern_url != 'NULL') { 
		var background_pattern_url = (board.attributes.background_pattern_url).replace("_XXXX.jpg", "_s.jpg"); 
  ;
__p += '\t\t\n <ul class="list-inline col-xs-offset-0 clearfix">\n    <li class="list-inline board-background-select navbar-btn cur col-xs-12">\n\t\n\t\t\t\t<ul class="list-inline clearfix">\n\t\t<li class="pull-left">\n\t\t\t<span class="background-box show well-lg" style="background-image:url(' +
((__t = ( background_pattern_url )) == null ? '' : __t) +
'); background-size:cover;"></span>\n\t\t</li>\n\t\t<li class="pull-left col-xs-8">\n\t\t\t<div class="clearfix">\n\t\t\t\t<p class="col-xs-5 nav htruncate"> ';
 if (!_.isEmpty(board.attributes.background_name) && board.attributes.background_name != 'NULL') { ;
__p += '\n\t\t\t\t\t' +
((__t = ( board.attributes.background_name )) == null ? '' : __t) +
' \n\t\t\t\t';
 } ;
__p += ' </p>\n\t\t\t\t<div class="pull-right">\n\t\t\t\t\t<div class="btn-group btn-group-xs navbar-btn">\n\t\t\t\t\t\t<a class="btn btn-primary js-modal-fliker-trigger" title="' +
__e( i18next.t('Change') ) +
'" href="#" data-type="texture" data-toggle="modal" data-target="#modalFlickrPhoto">' +
__e( i18next.t("Change") ) +
'</a>\n\t\t\t\t\t\t<div class="dropdown btn btn-default">\n\t\t\t\t\t\t\t<a data-toggle="dropdown" class="dropdown-toggle" title="' +
__e( i18next.t('Delete') ) +
'" href="#">\n\t\t\t\t\t\t\t\t<i class="icon-remove cur js-delete-background-img"></i>\n\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right list-unstyled">\n\t\t\t\t\t\t\t\t<li id="js-attachment-confirm-respons-22" class="js-dropdown-popup">\n\t\t\t\t\t\t\t\t  <div>\n\t\t\t\t\t\t\t\t\t<div class="clearfix text-center col-xs-12"><span class="col-xs-10"><strong>' +
__e( i18next.t("Delete Attachment") ) +
'?</strong></span><a href="#" class="js-span-close-popup pull-right"><i class="icon-remove"></i></a></div>\n\t\t\t\t\t\t\t\t\t<div class="col-xs-12 divider"></div>\n\t\t\t\t\t\t\t\t\t<div class="col-xs-12 text-left">\n\t\t\t\t\t\t\t\t\t  <p>' +
__e( i18next.t("Deleting an background photo. There is no undo.") ) +
'</p>\n\t\t\t\t\t\t\t\t\t  <a title="' +
__e( i18next.t('Delete background photo') ) +
'" class="btn btn-primary btn-large">' +
__e( i18next.t("Delete") ) +
'</a></div>\n\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div>\n\t\t\t\t<small class="navbar-btn">' +
__e( i18next.t("Powered by") ) +
' <a href="javascript:void(0);" title="' +
__e( i18next.t('Flickr') ) +
'"><strong class="text-primary">' +
__e( i18next.t("Flickr") ) +
'</strong></a></small>\n\t\t\t</div>\t\t\n\t\t</li>\n\t\t</ul>\n\t\t\n\t</li>\n  </ul>\n  ';
 } else { ;
__p += '\n\t <a href="#" class="js-modal-fliker-trigger" data-type="texture" data-toggle="modal" data-target="#modalFlickrPhoto">' +
__e( i18next.t("Choose...") ) +
'</a>\n  ';
 } ;
__p += '  \n \n  \n';
 if(authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "add_custom_background", board_user_role_id: parseInt(board.board_user_role_id)}))){ ;
__p += ' \n  <h4>' +
__e( i18next.t("Custom") ) +
'<span class="clearfix navbar-btn col-xs-7 pull-right"><span id="custom-dropzone-cssloader"></span></span></h4>\n  <ul class="js-board-background-custom-lists list-inline">\n    ';
 board.custom_attachments.each(function(custom_attachment) { ;
__p += '\n    <li class="js-change-custom-background board-background-select navbar-btn cur" data-background="' +
((__t = ( custom_attachment.get('path') )) == null ? '' : __t) +
'"><span class="background-box show well-lg" style="background-image:url(' +
((__t = ( custom_attachment.get('path') )) == null ? '' : __t) +
'"></span></li>\n    ';
 }); ;
__p += '\n  </ul>\n\n\n<div class="clearfix col-xs-12" id="custom-background-dropzone">\n\t<form id="js-board-custom-background-form" class="form-horizontal clearfix  js-cusotm-background-add" role="form" enctype="multipart/form-data">\n\t\t<div id="manager-area" class="js-cusotm-background-dropzone empty-block js-computer-open-board-background">\n\t\t\t' +
__e( i18next.t("Drop files to upload") ) +
'\n\t\t</div>\n\t</form>\n</div>\n';
 } ;
__p += '\n<div class="col-xs-12 member-modal clearfix btn-block">\n<h4>' +
__e( i18next.t("Productivity Beats") ) +
'</h4>\n';
 if (!_.isEmpty(board.attributes.music_content) && board.attributes.music_content != 'NULL') { ;
__p += '\n <ul class="list-inline col-xs-offset-0 clearfix">\n    <li class="clearfix col-xs-12">\n\t\n\t  <ul class="list-inline col-xs-offset-0">\n\t\t<li class="list-inline board-background-select navbar-btn cur col-xs-12">\n\n\t\t<ul class="list-inline clearfix">\n\t\t<li class="pull-left col-xs-12">\n\t\t\t<div class="clearfix">\n\t\t\t\t<p class="col-xs-7 nav htruncate">\n\t\t\t\t' +
((__t = ( board.attributes.music_name )) == null ? '' : __t) +
'\n\t\t\t\t</p>\n\t\t\t\t<div class="pull-right">\n\t\t\t\t\t<div class="btn-group btn-group-xs navbar-btn">\n\t\t\t\t\t\t<a class="btn btn-primary js-modal-music-trigger" title="' +
__e( i18next.t('Change') ) +
'" href="#" data-toggle="modal" data-target="#modalMusic">' +
__e( i18next.t("Change") ) +
'</a>\n\t\t\t\t\t\t<div class="dropdown btn btn-default">\n\t\t\t\t\t\t\t<a data-toggle="dropdown" class="dropdown-toggle" title="' +
__e( i18next.t('Delete') ) +
'" href="#">\n\t\t\t\t\t\t\t\t<i class="icon-remove cur js-music-clear"></i>\n\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right list-unstyled">\n\t\t\t\t\t\t\t\t<li id="js-attachment-confirm-respons-22" class="js-dropdown-popup">\n\t\t\t\t\t\t\t\t  <div>\n\t\t\t\t\t\t\t\t\t<div class="clearfix text-center col-xs-12"><span class="col-xs-10"><strong>' +
__e( i18next.t("Delete Attachment") ) +
'?</strong></span><a href="#" class="js-span-close-popup pull-right"><i class="icon-remove"></i></a></div>\n\t\t\t\t\t\t\t\t\t<div class="col-xs-12 divider"></div>\n\t\t\t\t\t\t\t\t\t<div class="col-xs-12 text-left">\n\t\t\t\t\t\t\t\t\t  <p>' +
__e( i18next.t("Deleting an background photo. There is no undo.") ) +
'</p>\n\t\t\t\t\t\t\t\t\t  <a title="' +
__e( i18next.t('Delete background photo') ) +
'" class="btn btn-primary btn-large">' +
__e( i18next.t("Delete") ) +
'</a></div>\n\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</div>\t\n\t\t</li>\n\t\t</ul>\t\n\t\n\t</li>\n  </ul>\n  ';
 } else { ;
__p += '\n\t<a href="#" class="js-modal-music-trigger" data-toggle="modal" data-target="#modalMusic">' +
__e( i18next.t("Add...") ) +
'</a>\n  ';
 } ;
__p += '  \n</div>\n</div>';

}
return __p
};

this["JST"]["templates/board_custom_background"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<span class="background-box" style="background-image:url(' +
((__t = (board_background.attributes.custom_attachments.path)) == null ? '' : __t) +
'"></span>';

}
return __p
};

this["JST"]["templates/board_filter"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\n\t<a href="#" class="js-back-to-sidebar pull-left btn btn-xs btn-link">\n\t\t\t<i class="icon-caret-left"></i>\n\t</a>\n\t<span class="col-xs-10 navbar-btn"><strong>' +
__e( i18next.t('Filter Cards') ) +
'</strong></span>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12 member-modal js-pre-scrollable vertical-scrollbar">\n\t';
 if (board.labels.length > 0) { ;
__p += '\n\t<ul class="nav nav-pills nav-stacked js-board-labels">\n\t';

	var labels = board.labels.pluck("name");
	labels = _.uniq(labels, function(label) { 
		return label;
	});
	 _.each(labels, function(label) { ;
__p += ' \n\t\t<li class="clearfix js-toggle-label-filter cur card-label-show h5 btn-link media">\n\t\t\t<span style="background:#' +
__e( converter.colorCode(''+label).substring(0, 6) ) +
';color:#ffffff" class="pull-left btn btn-xs"><i class="' +
((__t = ( LABEL_ICON )) == null ? '' : __t) +
' icon-light"></i></span><div class="htruncate js-label">' +
__e(label ) +
'</div>\n\t\t</li> \n\t';
 }); ;
__p += '\n\t</ul>\n\t<hr>\n\t';
 } ;
__p += '\n\t';
 if (board.board_users.length > 0) { ;
__p += '\n\t<ul class="nav nav-pills nav-stacked js-board-users">\n\t\t';
 board.board_users.each(function(board_user) { ;
__p += '\n\t\t<li class="clearfix js-toggle-member-filter cur card-label-show h5 btn-link">\n\t\t\t<div class="navbar-btn clearfix media">\n\t\t\t\t<span class="pull-left">\n\t\t\t\t\t';
 if(!_.isEmpty(board_user.attributes.profile_picture_path)){ 
						var profile_picture_path = board_user.showImage('User', board_user.attributes.user_id, 'small_thumb' );
			
					;
__p += '\n\t\t\t\t\t\t<img class="img-rounded img-responsive" src="' +
__e( profile_picture_path) +
'" alt="[Images: ' +
__e( board_user.attributes.username) +
']" title="' +
__e( board_user.attributes.username) +
'" />\n\t\t\t\t\t';
 }else{ ;
__p += '\n\t\t\t\t\t\t<i class="avatar avatar-color-194 img-rounded" title="' +
__e( board_user.attributes.username) +
'">' +
__e( board_user.attributes.initials) +
'</i>\n\t\t\t\t\t';
 } ;
__p += ' \n\t\t\t\t</span>\t\t\t\n\t\t\t\t<span class="pull-left navbar-btn htruncate">\n\t\t\t\t\t' +
__e(board_user.attributes.username ) +
'\n\t\t\t\t\t<span class="js-user hide">user-filter-' +
__e(board_user.attributes.user_id ) +
'</span>\n\t\t\t\t</span>\n\t\t\t</div>\n\t\t</li>\n\t\t';
 }); ;
__p += '\n\t</ul>\n\t<hr>\n\t';
 } ;
__p += '\n\t<ul class="nav nav-pills nav-stacked js-board-dues">\n\t\t<li class="clearfix js-due-filter cur card-label-show h5 btn-link"><div class="navbar-btn clearfix media htruncate">' +
__e( i18next.t('Due in the next day') ) +
' <span class="js-due hide">day</span></div></li>\n\t\t<li class="clearfix js-due-filter cur card-label-show h5 btn-link"><div class="navbar-btn clearfix media htruncate">' +
__e( i18next.t('Due in the next week') ) +
' <span class="js-due hide">week</span></div></li>\n\t\t<li class="clearfix js-due-filter cur card-label-show h5 btn-link"><div class="navbar-btn clearfix media htruncate">' +
__e( i18next.t('Due in the next month') ) +
' <span class="js-due hide">month</span></div></li>\n\t\t<li class="clearfix js-due-filter cur card-label-show h5 btn-link"><div class="navbar-btn clearfix media htruncate">' +
__e( i18next.t('Overdue') ) +
' <span class="js-due hide">overdue</span></div></li>\n\t</ul>\n\t<hr>\n\t<ul class="nav nav-pills nav-stacked">\n\t\t<li class="clearfix h5 btn-link">\n\t\t\t<span class="js-clear-all text-muted">' +
__e( i18next.t('Clear Filter') ) +
'</span>\n\t\t</li>\n\t</ul>\n</div>';

}
return __p
};

this["JST"]["templates/board_header"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += ' <div class="container-fluid">\n\t <div class="row">\n\t\t\t  <div class="navbar-left navbar-btn mob-no-mar col-sm-11 col-xs-10 nav ';
 if(board.attributes.organization_id == 0) { ;
__p += ' col-lg-6 col-md-5 ';
 } else { ;
__p += ' col-lg-5 col-md-4';
 } ;
__p += '">\n\t\t\t  <div class="clearfix row-flex">\n\t\t\t  <ul class="nav nav-pills pull-left col-flex col-flex1 ';
 if(board.attributes.organization_id == 0) { ;
__p += ' hide ';
 } ;
__p += '">\n\t\t\t  ';
 if(board.attributes.organization_id != 0) { ;
__p += '\n               <li>\n\t\t\t\t<a href="#/organization/' +
((__t = ( board.attributes.organization_id )) == null ? '' : __t) +
'" class=" text-muted btn btn-link pull-left htruncate col-lg-10 col-sm-10 col-md-9 col-xs-9 nav" title="' +
__e( board.attributes.organization_name ) +
'">\n\t\t\t\t\t';

						var logo_path = "img/default-organization.png"; 
						if (!_.isUndefined(board.attributes.organization_logo_url) && board.attributes.organization_logo_url != null && board.attributes.organization_logo_url != '') {
							logo_path = board.showImage('Organization', board.attributes.organization_id, 'small_thumb' );
						}
					;
__p += '\n\t\t\t\t\t<span><img src="' +
((__t = ( logo_path )) == null ? '' : __t) +
'" height="16" width="16" alt="[Image: ' +
((__t = ( board.attributes.organization_name)) == null ? '' : __t) +
']" title="' +
((__t = ( board.attributes.organization_name)) == null ? '' : __t) +
'"></span> \n\t\t\t\t\t<strong>' +
__e( board.attributes.organization_name ) +
'</strong>\n\t\t\t\t</a>\n\t\t\t\t<span class="navbar-btn mob-no-mar pull-left icon"><span class="navbar-btn pull-left">&nbsp;/&nbsp;</span></span>\n\t\t\t   </li>\n\t\t\t   ';
 } ;
__p += '\n\t\t\t</ul>\n\t\t\t<div class="navbar-btn pull-left mob-no-mar list-group-item-text col-flex ';
 if(board.attributes.organization_id != 0) { ;
__p += ' col-flex2 ';
 } else { ;
__p += ' col-flex3  ';
 } ;
__p += '">\t\n\t\t\t\t\t  <form name="BoardStarForm" id="BoardStarForm">\n\t\t\t\t\t\t<input id="inputBoardStar" name="is_starred" type="hidden" value="';
if(!_.isUndefined(star)) {;
__p +=
__e( star.attributes.is_starred );
}else{;
__p += '0';
};
__p += '"> \n\t\t\t\t\t  </form>\n\t\t\t\t\t<div class="col-xs-12 pull-left navbar-btn list-group-item-text ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(board.acl_links.where({slug: 'edit_board',board_user_role_id: parseInt(board.board_user_role_id)})))) { ;
__p += 'dropdown';
 } ;
__p += '">\n\t\t\t\t\t  ';
 if(!_.isEmpty(role_links.where({slug: "starred_board"}))){ ;
__p += '\n\t\t\t\t\t  ';
 if(!_.isUndefined(star) && (parseInt(star.attributes.is_starred) === 1)) { ;
__p += '\n\t\t\t\t\t  <a href="#" class="js-star-board pull-left" name="unstar" title="\n' +
__e( i18next.t('Unstar') ) +
'"><i class="icon-star text-primary"></i></a>\n\t\t\t\t\t  ';
 } else { ;
__p += '\n\t\t\t\t\t  <a href="#" class="js-star-board pull-left" name="star" title="\n' +
__e( i18next.t('Star') ) +
'"><i class="icon-star-empty"></i></a>\n\t\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t\t  <a href="#" class="js-star-load pull-left text-primary hide"><img src="img/star-load.gif" alt="[Images: Star]" title="\n' +
__e( i18next.t('Star') ) +
'"></a><a href="#" class="col-xs-8 nav htruncate ';
if(!_.isUndefined(authuser.user)) {;
__p += 'js-rename-board';
}else{;
__p += 'js-no-action';
};
__p += '" data-toggle="';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: 'edit_board',board_user_role_id: parseInt(board.board_user_role_id)})))) { ;
__p += 'dropdown';
 } ;
__p += '" title="' +
__e( board.attributes.name ) +
'"><strong>' +
__e( board.attributes.name ) +
'</strong></a>\n\t\t\t\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "edit_board",board_user_role_id: parseInt(board.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow arrow-left">\n\t\t\t\t\t<li class="js-rename-popup js-dropdown-popup dropdown-popup">\n\t\t\t\t\t  <div class="clearfix text-center col-xs-12">\n\t\t\t\t\t\t<span class="col-xs-10"><strong>\n' +
__e( i18next.t('Rename Board') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\n\t\t\t\t\t  </div>\n\t\t\t\t\t  <div class="col-xs-12 divider"></div>\n\t\t\t\t\t  <div class="col-xs-12 text-left">\n\t\t\t\t\t\t<form class="normal" name="BoardRenameForm" id="BoardRenameForm">\n\t\t\t\t\t\t  <div class="required form-group">\n\t\t\t\t\t\t\t<label for="inputBoardName">\n' +
__e( i18next.t('Name') ) +
'</label>\n\t\t\t\t\t\t\t<input type="text" id="inputBoardName" name="name" class="form-control input-sm" title="\n' +
__e( i18next.t('Whitespace alone not allowed') ) +
'" required pattern=".*\\S+.*" value="' +
__e( board.attributes.name ) +
'">\n\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t  <div class="submit">\n\t\t\t\t\t\t\t<input type="submit" value="\n' +
__e( i18next.t('Rename') ) +
'" id="submitBoardRename" class="btn btn-primary btn-sm">\n\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t</form>\n\t\t\t\t\t  </div>\n\t\t\t\t\t</li>\n\t\t\t\t  </ul>\n\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t  </div>\n\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t\t <div class="navbar-header"><button data-toggle="collapse" data-target=".navbar-collapse" class="navbar-toggle" type="button"> <span class="sr-only">\n' +
__e( i18next.t('Toggle navigation') ) +
'</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> </button></div>\n\t\t\t<nav class="navbar-collapse collapse mob-no-pad">\n\t\t\t  <div class="navbar-right">\n\t\t\t  ';
 if(!_.isUndefined(authuser.user)){ ;
__p += '\n\t\t\t  <ul class="nav nav-pills pull-left pillsuser-list navbar-btn h4 right-mar">\n\t\t\t\t  <li class="dropdown"> <a href="javascript:void(0);" data-toggle="dropdown" class="dropdown-toggle show clearfix navbar-btn h4">\n\t\t\t\t  ';
 
			  var i = 1;
			  var admin_board_users_count = board.admin_board_users.length;
			  var normal_board_users_count = board.normal_board_users.length;
			  _.each(board.admin_board_users, function(admin_board_user){ 
				if(i <= 3){
			  ;
__p += '\n            \t<span class="pull-left btn-xs nav">\n\t\t\t\t\t<span class="col-xs-12 btn-block navbar-btn" title="' +
__e(admin_board_user.attributes.full_name ) +
' (' +
__e(admin_board_user.attributes.username ) +
')">\n\t\t\t\t\t\t';
 if(!_.isEmpty(admin_board_user.attributes.profile_picture_path)) {
								var profile_picture_path = board.showImage('User', admin_board_user.attributes.user_id, 'small_thumb' );;
__p += '\n\t\t\t\t\t\t<img  width="30" height="30" class="img-responsive img-rounded board-user-img" title="' +
__e(admin_board_user.attributes.full_name ) +
' (' +
__e(admin_board_user.attributes.username ) +
')" alt="[Images: ' +
__e(admin_board_user.attributes.full_name ) +
']" src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'">\n\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t<i class="avatar avatar-sm avatar-color-194 img-rounded">' +
((__t = ( (admin_board_user.attributes.initials) )) == null ? '' : __t) +
'</i>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t';
 if(board.board_user_roles[admin_board_user.attributes.board_user_role_id - 1].id === 1){ ;
__p += '\n\t\t\t\t\t\t\t<span class="name-block htruncate col-xs-12 label btn-xs col-xs-push-0">\n' +
__e( i18next.t('Owner') ) +
'</span>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t</span>\n\t\t\t\t</span>\n\t\t\t  ';
 i++; }}); ;
__p += '\n\t\t\t  ';
 if(admin_board_users_count < 3){ 
			   _.each(board.normal_board_users, function(normal_board_user){
				if(i <= 3){
				var mobHidden='';
				if(i !== 1){
				  mobHidden = 'hidden-xs';
				}
			  ;
__p += '\n            \t<span class="pull-left btn-xs nav ' +
__e( mobHidden ) +
'">\n\t\t\t\t\t<span class="col-xs-12 btn-block navbar-btn" title="' +
__e(normal_board_user.attributes.full_name ) +
' (' +
__e(normal_board_user.attributes.username ) +
')">\n\t\t\t\t\t\t';
 if(!_.isEmpty(normal_board_user.attributes.profile_picture_path)) {
								var profile_picture_path = board.showImage('User', normal_board_user.attributes.user_id, 'small_thumb' );;
__p += '\n\t\t\t\t\t\t<img  width="30" height="30" class="img-responsive img-rounded board-user-img" title="' +
__e(normal_board_user.attributes.full_name ) +
' (' +
__e(normal_board_user.attributes.username ) +
')" alt="[Images: ' +
__e(normal_board_user.attributes.full_name ) +
']" src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'">\n\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t<i class="avatar avatar-sm avatar-color-194 img-rounded">' +
((__t = ( (normal_board_user.attributes.initials) )) == null ? '' : __t) +
'</i>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t</span>\n\t\t\t\t</span>\n\t\t\t  ';
 i++; }}); };
__p += '\n\t\t\t\t  <span class="col-xs-3 label small hidden-xs"> <span class="small"><span class="show text-left" title="' +
__e( i18next.t('Owner %s', { postProcess: 'sprintf', sprintf: [admin_board_users_count]}) ) +
'">' +
__e( i18next.t('Owner %s', { postProcess: 'sprintf', sprintf: [admin_board_users_count]}) ) +
'</span> <span class="show text-left" title="' +
__e( i18next.t('Member %s', { postProcess: 'sprintf', sprintf: [normal_board_users_count]}) ) +
'">' +
__e( i18next.t('Member %s', { postProcess: 'sprintf', sprintf: [normal_board_users_count]}) ) +
'</span></span> </span> </a>\n\t\t\t\t\t<ul class="list-unstyled js-visibility-chooser dropdown-menu arrow arrow-right">\n\t\t\t\t\t  <li class="text-center">\n\t\t\t\t\t\t<strong>' +
__e( i18next.t('Members') ) +
'</strong>\n\t\t\t\t\t\t<span href="#" class="js-close-popover pull-right col-xs-2"><i class="icon-remove cur"></i></span>\n\t\t\t\t\t  </li>\n\t\t\t\t\t  <li class="divider"></li>\n\t\t\t\t\t  <li class="col-xs-12">\n\t\t\t\t\t\t<ul class="list-unstyled clearfix js-get-board-member-lists-response">\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "add_board_users",board_user_role_id: parseInt(board.board_user_role_id)})))) {;
__p += '\n\t\t\t\t\t\t<ul class="list-unstyled clearfix js-hide-on-offline">\n\t\t\t\t\t\t<li class="col-xs-12 navbar-btn text-left">\n\t\t\t\t\t\t\t\t<div class="js-add-board-member-dropdown dropdown inner-dropdown col-xs-12"> \n\t\t\t\t\t\t\t\t\t<a href="#" class="text-muted" data-toggle="dropdown">' +
__e( i18next.t('Add Member') ) +
'...</a>\n\t\t\t\t\t\t\t\t\t<ul class="dropdown-menu arrow">\n\t\t\t\t\t\t\t\t\t\t<li>\n\t\t\t\t\t\t\t\t\t\t  <div class="col-xs-12 text-center clearfix">\n\t\t\t\t\t\t\t\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Members') ) +
'</strong></span><a class="js-close-popover-board-member-dropdown pull-right" href="#"><i class="icon-remove"></i></a>\t\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\t\t  </div> \n\t\t\t\t\t\t\t\t\t\t  <div class="col-xs-12 divider"></div>\n\t\t\t\t\t\t\t\t\t\t  <div class="col-xs-12">\n\t\t\t\t\t\t\t\t\t\t\t<form method="post" class="text-center" id="js-add-board-member-form">\n\t\t\t\t\t\t\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t\t\t\t\t\t\t<label class="sr-only">' +
__e( i18next.t('Search Member') ) +
'</label>\n\t\t\t\t\t\t\t\t\t\t\t\t<input type="text" autocomplete="off" id="inputBoardUserSearch" placeholder="' +
__e( i18next.t('Email or Username') ) +
'" name="email" title="' +
__e( i18next.t('Email or Username') ) +
'" required class="js-search-users form-control input-sm">\n\t\t\t\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t\t\t\t</form>\n\t\t\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t\t\t  </li>\n\t\t\t\t\t\t\t\t\t\t  <li class="js-board-member-search-response col-xs-12 pre-scrollable vertical-scrollbar">\n\t\t\t\t\t\t\t\t\t\t\t<span class="small">' +
__e( i18next.t('Search for a person in %s by name or email address.', { postProcess: 'sprintf', sprintf: [SITE_NAME]}) ) +
'</span>\n\t\t\t\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t  </li>\n\t\t\t\t\t</ul>\n\t\t\t\t  </li>\n\t\t\t\t</ul>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t<ul class="nav nav-pills pull-left">\n\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "edit_board", board_user_role_id: parseInt(board.board_user_role_id)})))) { ;
__p += ' \n\t\t\t\t\t<li>\n\t\t\t\t\t\t<div class="btn-group navbar-btn js-visibility-list-dropdown dropdown">\n\t\t\t\t\t\t\t';
 	var board_visibility = '';
								var board_visibility_icon = '';
								if(board.attributes.board_visibility == 0) { 
									board_visibility = i18next.t('Private');
									board_visibility_icon = 'icon-lock';
								} else if(board.attributes.board_visibility == 1 && board.attributes.organization_id > 0) {
									board_visibility = i18next.t('Organization');
									board_visibility_icon = 'icon-group';
								} else if(board.attributes.board_visibility == 2) {
									board_visibility = i18next.t('Public');
									board_visibility_icon = 'icon-circle';
								}
							;
__p += '\n\t\t\t\t\t\t\t<button class="btn btn-default btn-sm js-board-visibility" type="button"><i class="' +
__e( board_visibility_icon) +
'"></i><span class="hidden-xs">' +
((__t = ( board_visibility )) == null ? '' : __t) +
'</span></button>\n\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t<button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle active js-board-visibility" type="button"> <span><i class="icon-caret-down cur"></i></span> <span class="sr-only">' +
__e( i18next.t('Toggle Dropdown') ) +
'</span> </button>\n\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right col-xs-push-0">\n\t\t\t\t\t\t\t\t<li class="js-visibility-popup js-dropdown-popup dropdown-popup col-xs-12">          \n\t\t\t\t\t\t\t\t\t<div class="clearfix text-center"><a class="js-back-to-board-visibility hide pull-left" href="#"><i class="icon-caret-left"></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t('Change Visibility') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\n\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\t<li class="col-xs-12 divider js-visibility-list"></li>\n\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t</div>\n\t              </li>\n\t\t\t\t  ';
 } else { ;
__p += '\n\t\t\t\t\t<li>\n\t\t\t\t\t\t<div class="btn-group navbar-btn js-visibility-list-dropdown dropdown">\n\t\t\t\t\t\t\t';
 	var board_visibility = '';
								var board_visibility_icon = '';
								if(board.attributes.board_visibility == 0) { 
									board_visibility = 'Private';
									board_visibility_icon = 'icon-lock';
								} else if(board.attributes.board_visibility == 1 && board.attributes.organization_id > 0) {
									board_visibility = 'Organization';
									board_visibility_icon = 'icon-group';
								} else if(board.attributes.board_visibility == 2) {
									board_visibility = 'Public';
									board_visibility_icon = 'icon-circle';
								}
							;
__p += '\n\t\t\t\t\t\t\t<button class="btn btn-default btn-sm" type="button"><i class="' +
__e( board_visibility_icon) +
'"></i><span class="hidden-xs">' +
((__t = ( board_visibility )) == null ? '' : __t) +
'</span></button>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</li>\n\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t  \n\t\t\t\t  <li class="js-switch-view"><a href="#" class=" navbar-btn h4 js-switch-grid-view text-muted list-group-item-text" title="' +
__e( i18next.t('Grid') ) +
'" data-placement="bottom" data-toggle="tooltip"><i class="icon-th"></i></a></li>\n\t\t\t\t  <li class="js-switch-view"><a href="#" class=" navbar-btn h4 js-switch-list-view text-muted list-group-item-text" title="' +
__e( i18next.t('List') ) +
'" data-placement="bottom" data-toggle="tooltip"><i class="icon-list-ul"></i></a></li>\n\t\t\t\t  <li class="js-switch-view"><a href="#" class=" navbar-btn h4 js-switch-calendar-view text-muted list-group-item-text" title="' +
__e( i18next.t('Calendar') ) +
'" data-placement="bottom" data-toggle="tooltip"><i class="icon-calendar"></i></a></li>\n\t\t\t\t  <li class="js-switch-view"><a href="#" class=" navbar-btn h4 js-switch-timeline-view text-muted list-group-item-text" title="' +
__e( i18next.t('Gantt') ) +
'" data-placement="bottom" data-toggle="tooltip"><i class="icon-time"></i></a></li>\n\t\t\t\t</ul>\n\t\t\t\t<div class="pull-right dropdown"> \n\t\t\t\t  <a data-toggle="dropdown" class="navbar-btn icon h4 btn btn-primary dropdown-toggle js-back-setting-response col-sm-offset-1 show" type="button"><i class="icon-cog h3 cur"></i></a>\n\t\t\t\t  <ul class="dropdown-menu arrow arrow-right col-xs-12 js-setting-response">\n\t\t\t\t\t\t\t<li class="js-list-form"><a class="nav-list-item js-show-filters" href="#"><span class="icon-sm icon-filter icon-type"></span> ' +
__e( i18next.t('Filter Cards') ) +
'</a></li>\n\t\t\t\t\t\t\t<li><a class="nav-list-item js-show-labels" href="#"><span class="icon-sm  icon-tag icon-type"></span> ' +
__e( i18next.t('Labels') ) +
'</a></li>\n\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user)) {;
__p += '\n\t\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "view_archived_lists",board_user_role_id: parseInt(board.board_user_role_id)})) || !_.isEmpty(board.acl_links.where({slug: "view_archived_cards",board_user_role_id: parseInt(board.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t\t\t<li><a class="nav-list-item js-archived-items" href="#"><span class="icon-sm icon-archive icon-type"></span> ' +
__e( i18next.t('Archived Items') ) +
'</a></li>\n\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user)){ ;
__p += '\n\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "view_sync_calendar",board_user_role_id: parseInt(board.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t\t<li class="js-sync-google-dropdown inner-dropdown"><a href="#" class="js-syn-google-calendar" data-toggle="dropdown"><span class="icon-calendar"></span> ' +
__e( i18next.t('iCal Feed') ) +
'</a>\n\t\t\t\t\t\t\t</li> \n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t<li class="divider"></li>\n\t\t\t\t\t\t\t';
if(!_.isUndefined(authuser.user)) {;
__p += ' \n\t\t\t\t\t\t\t  <li class="navbar-btn right-mar">\n\t\t\t\t\t\t\t\t<form name="BoardSubscribeForm" id="BoardSubscribeForm">\n\t\t\t\t\t\t\t\t  <input id="inputBoardSubscribe" name="is_subscribed" type="hidden" value=" ';
 if(!_.isUndefined(subscriber)) { ;
__p += ' ' +
__e( subscriber.attributes.is_subscribed );
}else{;
__p += '0';
};
__p += '">\n\t\t\t\t\t\t\t\t</form> \n\t\t\t\t\t\t\t\t';
 if(!_.isUndefined(subscriber) && parseInt(subscriber.attributes.is_subscribed)) { ;
__p += '\n\t\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "board_subscriber",board_user_role_id: parseInt(board.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t\t\t<a href="#" class="js-show-unsubscribe-form navbar-btn h4 list-group-item-text" name="unsubscribe" title="' +
__e( i18next.t('Subscribed') ) +
'"><i class="icon-eye-close"></i><span class="hidden-xs">' +
__e( i18next.t('Subscribed') ) +
' <i class="icon-ok js-filter-icon cur"></i></span></a>\n\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t';
 } else {;
__p += '  \n\t\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || ((!_.isEmpty(board.acl_links.where({slug: "subscribe_board",board_user_role_id: parseInt(board.board_user_role_id)})))  || (!_.isEmpty(role_links.where({slug: "subscribe_board"})) && board.attributes.board_visibility == 2)))){ ;
__p += '\n\t\t\t\t\t\t\t\t<a href="#" class="js-show-subscribe-form navbar-btn h4" name="subscribe" title="' +
__e( i18next.t('Subscribe') ) +
'"><i class="icon-eye-open"></i><span class="hidden-xs">' +
__e( i18next.t('Subscribe') ) +
'</span></a>\n\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t  </li>\n\t\t\t\t\t\t    ';
 };
__p += '\n\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "edit_board",board_user_role_id: parseInt(board.board_user_role_id)})))) {;
__p += '\n\t\t\t\t\t\t\t';
 
								var background_color = board.attributes.background_color; 
								var background_picture_url = board.attributes.background_picture_url; 
								var background_pattern_url = board.attributes.background_pattern_url; 
								var preview = ''; 
								if (!_.isEmpty(background_picture_url) && background_picture_url != 'NULL') { 
									background_picture_url = background_picture_url.replace("_XXXX.jpg", "_b.jpg");
									preview = '<span style="background-image:url(' + background_picture_url + ');" class="background-box show well-lg"></span>'; 
								 } else if (!_.isEmpty(background_pattern_url) && background_pattern_url != 'NULL') { 
									background_pattern_url = background_pattern_url.replace("_XXXX.jpg", "_b.jpg");
									preview = '<span style="background-image:url(' + background_pattern_url + ');" class="background-box show well-lg"></span>'; 
								 } else if (!_.isEmpty(background_color) && background_color != 'NULL') { 
									preview = '<span style="background-color:' + background_color + '" class=" background-box show well-lg"></span>'; 
								 }
							;
__p += '\n\t\t\t\t\t\t\t<li><a href="#" class="nav-list-item nav-list-sub-item js-change-background"> ' +
__e( i18next.t('Change Background') ) +
'</a></li>\n\t\t\t\t\t\t\t';
 if(!_.isEmpty(IMAP_EMAIL)){ ;
__p += '\n\t\t\t\t\t\t\t<li><a href="#" class="nav-list-item nav-list-sub-item js-email-to-board-settings"> ' +
__e( i18next.t('Email to board settings') ) +
'</a></li>\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t';
 };
__p += '\n\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "copy_board",board_user_role_id: parseInt(board.board_user_role_id)})))) {;
__p += '\n\t\t\t\t\t\t\t<li class="js-sync-google-dropdown inner-dropdown"><a data-toggle="dropdown" href="#" class="js-show-copy-board">' +
__e( i18next.t('Copy board') ) +
'</a>\n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t';
 };
__p += '\n\t\t\t\t\t\t\t';
 };
__p += '\n\t\t\t\t\t\t\t<li class="divider"></li>\n\t\t\t\t\t\t\t<li><a href="#" class="js-show-board-modal" data-toggle="modal" data-target="#modalListView">' +
__e( i18next.t('Show Attachments') ) +
'</a></li>\n\t\t\t\t\t\t\t<li><a href="#" class="js-show-chat-history-modal" data-toggle="modal" data-target="#modalChatHistoryView">' +
__e( i18next.t('Show Chat History') ) +
'</a></li>\n\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "edit_board",board_user_role_id: parseInt(board.board_user_role_id)})))) {;
__p += '\n\t\t\t\t\t\t\t<li><a href="#" class="js-additional-settings">' +
__e( i18next.t('Additional Settings') ) +
'</a></li>\n\t\t\t\t\t\t\t<li class="divider"></li>\n\t\t\t\t\t\t\t<li class="dropdown js-open-dropdown inner-dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-sm icon-warning-sign icon-type text-primary"></i>' +
__e( i18next.t('Close board') ) +
'</a>\n\t\t\t\t\t\t\t  <ul class="dropdown-menu arrow pull-right">\n\t\t\t\t\t\t\t\t<li class="js-dropdown-popup dropdown-popup">\n\t\t\t\t\t\t\t\t  <div class="clearfix text-center col-xs-12">\n\t\t\t\t\t\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Close board') ) +
'</strong></span><a class="js-close-sub-popover pull-right" href="#"><i class="icon-remove"></i></a>\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t  <div class="col-xs-12 divider"></div>\n\t\t\t\t\t\t\t\t  <div class="col-xs-12">\n\t\t\t\t\t\t\t\t\t<form class="normal col-xs-12" name="BoardCloseForm" id="BoardCloseForm">\n\t\t\t\t\t\t\t\t\t  <input id="inputBoardClose" name="is_closed" type="hidden" value="true">\n\t\t\t\t\t\t\t\t\t  <p>' +
__e( i18next.t('You can reopen the board by clicking the "Boards" menu from the header, selecting "View Closed Boards", finding the board and clicking "Reopen".') ) +
'</p>\n\t\t\t\t\t\t\t\t\t  <div class="submit">\n\t\t\t\t\t\t\t\t\t\t<input type="submit" value="' +
__e( i18next.t('Close') ) +
'" id="submitBoardClose" class="btn btn-primary js-close-board">\n\t\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t\t</form>\n\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t  </ul>\n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t  </ul>\n\t\t\t\t</div>\n\t\t\t  </div>\n\t\t\t  </nav>\n\t\t</div>\n\t</div>\n';

}
return __p
};

this["JST"]["templates/board_index"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '  ';
 if(!_.isEmpty(role_links.where({slug: "view_my_boards"}))){ ;
__p += '\n  <div class="btn-block clearfix">\n    <div class="col-xs-12 js-my-boards mob-no-pad">\n    </div>\n  </div>\n  ';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/board_index_header"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="container-fluid">\n\t<div class="row">\n        <div class="pull-left">\n            <div class="clearfix">\n                <h2 class="pull-left navbar-btn list-group-item-text"><span class="pull-left"><a href="#/" title="' +
__e( SITE_NAME ) +
'"><img src="img/logo.png" alt="[Image: ' +
__e( SITE_NAME ) +
']" title="' +
__e( SITE_NAME ) +
'" class="img-responsive center-block"/></a></span>\n\t\t\t\t\t<ul class="list-inline pull-left h3 navbar-btn text-center">\n\t\t\t\t\t\t <li class="navbar-btn text-muted"><span class="h5">&nbsp;/&nbsp;</span></li>\n\t\t\t\t\t\t<li><span class="text-muted h4">' +
__e( i18next.t('Dashboard') ) +
'</span></li>\n\t\t\t\t\t</ul>\n\t\t\t\t</h2>\n            </div>\n        </div>\n\t\t<div class="navbar-header"><button data-toggle="collapse" data-target=".navbar-collapse" class="navbar-toggle" type="button"> <span class="sr-only">' +
__e( i18next.t('Toggle navigation') ) +
'</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> </button></div>\n    </div>\n</div>    ';

}
return __p
};

this["JST"]["templates/board_labels"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\n\t<a href="#" class="js-back-to-sidebar pull-left btn btn-xs btn-link">\n\t\t\t<i class="icon-caret-left"></i>\n\t</a>\n\t<span class="col-xs-10 navbar-btn"><strong>' +
__e( i18next.t('Labels') ) +
'</strong></span>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12 member-modal js-pre-scrollable vertical-scrollbar">\n\t';
 if (board.labels.length > 0) { ;
__p += '\n\t<ul class="nav nav-pills nav-stacked label-block">\n\t';
 
		var labels = Array();
		board.labels.each(function(label) {
			if (!_.contains(labels, label.attributes.name)) {
				labels.push(label.attributes.name);
		;
__p += '    \n\t\t<li class="clearfix cur card-label-show h5 btn-link media">\n\t\t\t<span style="background:#' +
__e( converter.colorCode(label.attributes.name).substring(0, 6) ) +
';color:#ffffff" class="pull-left btn btn-xs"><i class="' +
((__t = ( LABEL_ICON )) == null ? '' : __t) +
' icon-light"></i></span><div class="htruncate">' +
__e(label.attributes.name ) +
'</div><div><a data-id="' +
__e( label.attributes.label_id ) +
'" class="js-delete-labels btn btn-default btn-xs pull-right" data-toggle="dropdown">\n\t\t\t<i class="icon-remove cur"></i></a></div> \n\t\t</li> \n\t';
		}
		}); 
		;
__p += '\n\t</ul>\n\t<hr>\n\t';
 }else{ ;
__p += '\n\t<span class="alert alert-info">\n\t\t' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('labels')] }) ) +
'\n    </span>\n\t';
 } ;
__p += '\n</div>';

}
return __p
};

this["JST"]["templates/board_member_add_search_result"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<span title="' +
__e( user.attributes.full_name ) +
' (' +
__e( user.attributes.username ) +
')"> <span>\t\t\t\t\n\t\t\t\t';
 if(!_.isEmpty(user.attributes.profile_picture_path)) { 
					var profile_picture_path = user.showImage('User', user.attributes.id, 'micro_thumb' );
				;
__p += '\n\t\t\t\t\t<img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(user.attributes.username ) +
']" title="' +
__e( user.attributes.full_name ) +
' (' +
__e(user.attributes.username ) +
')" class="img-rounded img-responsive avatar  avatar-sm">\n\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t<i class="avatar avatar-color-194 avatar-sm img-rounded">' +
__e( user.attributes.initials ) +
'</i>\t\t\t\t\t\t\t\t\t\n\t\t\t\t';
 } ;
__p += '\n</span><span>' +
__e( user.attributes.full_name ) +
' (' +
__e( user.attributes.username ) +
')</span></span>';

}
return __p
};

this["JST"]["templates/board_organization_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 

	var organization_options = ''; 
	var is_org_found = false;
	var display_options = false;
	_.each(organizations.models, function(organization) { 
		display_options = true;
		if(parseInt(organization.id) === board.attributes.organization_id){
			is_org_found = true;
		}
		var selected = (parseInt(organization.id) === board.attributes.organization_id) ? 'selected="selected"' : '';
		var current = (parseInt(organization.id) === board.attributes.organization_id) ? ' '+i18next.t('(current)') : ''; 
		organization_options += '<option value="' + organization.id + '" ' + selected + '>' + _.escape(organization.attributes.name) + current + '</option>'; 
	}); 
	if(!is_org_found && board.attributes.organization_id != 0){
		display_options = true;
		organization_options += '<option value="' + board.attributes.organization_id + '" selected="selected" >' + _.escape(board.attributes.organization_name) + ' '+i18next.t('(current)')+'</option>'; 
	}
;
__p += ' \n<form class="normal js-save-board-visibility" name="BoardVisibilityForm">\n<div class="form-group select"><label for="inputListBoard">' +
__e( i18next.t('Organization') ) +
'</label><select name="organization_id" class="form-control cur" required>';
 if (display_options) {;
__p += '<option value="">' +
__e( i18next.t('Please select organization') ) +
'</option>' +
((__t = (organization_options )) == null ? '' : __t);
}else{;
__p += '<option value="">' +
__e( i18next.t('(none)') ) +
'</option>';
};
__p += '</select></div><div class="submit"><input type="submit" class="btn btn-primary" value="' +
__e( i18next.t('Save') ) +
'" ';
 if (!display_options) {;
__p +=
__e( i18next.t('Disabled') ) +
' ';
};
__p += '></div>\n</form>';

}
return __p
};

this["JST"]["templates/board_sidebar"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 
	var background_color = board.attributes.background_color; 
    var background_picture_url = board.attributes.background_picture_url; 
    var background_pattern_url = board.attributes.background_pattern_url; 
    var preview = ''; 
    if (!_.isEmpty(background_picture_url) && background_picture_url != 'NULL') { 
		background_picture_url = background_picture_url.replace("_XXXX.jpg", "_b.jpg");
    	preview = '<span style="background-image:url(' + background_picture_url + ');" class="background-box show well-lg"></span>'; 
     } else if (!_.isEmpty(background_pattern_url) && background_pattern_url != 'NULL') { 
		background_pattern_url = background_pattern_url.replace("_XXXX.jpg", "_s.jpg");
     	preview = '<span style="background-image:url(' + background_pattern_url + ');" class="background-box show well-lg"></span>'; 
     } else if (!_.isEmpty(background_color) && background_color != 'NULL') { 
     	preview = '<span style="background-color:' + background_color + '" class=" background-box show well-lg"></span>'; 
     }
;
__p += ' \n<li class="js-list-form"><a class="nav-list-item js-show-filters" href="#"><span class="icon-sm icon-filter icon-type"></span> ' +
__e( i18next.t('Filter Cards') ) +
'</a></li>\n<li><a class="nav-list-item js-show-labels" href="#"><span class="icon-sm  icon-tag icon-type"></span> ' +
__e( i18next.t('Labels') ) +
'</a></li>\n';
 if(!_.isUndefined(authuser.user)) {;
__p += '\n\t';
 if(authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "view_archived_lists",board_user_role_id: parseInt(board.board_user_role_id)})) || !_.isEmpty(board.acl_links.where({slug: "view_archived_cards",board_user_role_id: parseInt(board.board_user_role_id)}))) { ;
__p += '\n\t<li><a class="nav-list-item js-archived-items" href="#"><span class="icon-sm icon-archive icon-type"></span> ' +
__e( i18next.t('Archived Items') ) +
'</a></li>\n\t';
 } ;
__p += '\n';
 } ;
__p += ' \n';
if(!_.isUndefined(authuser.user)) {;
__p += '\n';
 if(authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "view_sync_calendar",board_user_role_id: parseInt(board.board_user_role_id)}))) { ;
__p += '\n<li class="dropdown js-sync-google-dropdown inner-dropdown"><a href="#" class="js-syn-google-calendar" data-toggle="dropdown"><span class="icon-calendar"></span> ' +
__e( i18next.t('iCal Feed') ) +
'</a></li>\n';
 } ;
__p += '\n<li class="divider"></li>\n';
if(!_.isUndefined(authuser.user)) {;
__p += ' \n  <li class="navbar-btn right-mar">\n\t<form name="BoardSubscribeForm" id="BoardSubscribeForm">\n\t  <input id="inputBoardSubscribe" name="is_subscribed" type="hidden" value=" ';
 if(!_.isUndefined(subscriber)) { ;
__p += ' ' +
__e( subscriber.attributes.is_subscribed );
}else{;
__p += '0';
};
__p += '">\n\t</form> \n\t';
 if(!_.isUndefined(subscriber) && parseInt(subscriber.attributes.is_subscribed)) { ;
__p += '\n\t';
 if(authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "board_subscriber",board_user_role_id: parseInt(board.board_user_role_id)}))) { ;
__p += '\n\t<a href="#" class="js-show-unsubscribe-form navbar-btn h4 list-group-item-text" name="unsubscribe" title="' +
__e( i18next.t('Subscribed') ) +
'"><i class="icon-eye-close"></i><span class="hidden-xs">' +
__e( i18next.t('Subscribed') ) +
' <i class="icon-ok js-filter-icon cur"></i></span></a>\n\t';
 } ;
__p += '\n\t';
 } else {;
__p += ' \n\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || ((!_.isEmpty(board.acl_links.where({slug: "subscribe_board",board_user_role_id: parseInt(board.board_user_role_id)})))  || (!_.isEmpty(role_links.where({slug: "subscribe_board"})) && board.attributes.board_visibility == 2)))){ ;
__p += '\n\t<a href="#" class="js-show-subscribe-form navbar-btn h4" name="subscribe" title="' +
__e( i18next.t('Subscribe') ) +
'"><i class="icon-eye-open"></i><span class="hidden-xs">' +
__e( i18next.t('Subscribe') ) +
'</span></a>\n\t';
 } ;
__p += '\n\t';
 } ;
__p += '\n  </li>\n';
 } ;
__p += '  \n';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "edit_board",board_user_role_id: parseInt(board.board_user_role_id)})))) {;
__p += '\n<li><a href="#" class="nav-list-item nav-list-sub-item js-change-background">' +
__e( i18next.t('Change Background') ) +
'</a></li>\n';
 if(!_.isEmpty(IMAP_EMAIL)){ ;
__p += '\n<li><a href="#" class="nav-list-item nav-list-sub-item js-email-to-board-settings"> ' +
__e( i18next.t('Email to board settings') ) +
'</a></li>\n';
 } ;
__p += '\n';
 } ;
__p += '\n';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "copy_board",board_user_role_id: parseInt(board.board_user_role_id)})))) {;
__p += '\n\t<li class="js-sync-google-dropdown inner-dropdown"><a data-toggle="dropdown" href="#" class="js-show-copy-board">' +
__e( i18next.t('Copy board') ) +
'</a></li>\n';
 };
__p += '\n';
 } ;
__p += '\n<li class="divider"></li>\n<li><a href="#" class="js-show-board-modal" data-toggle="modal" data-target="#modalListView">' +
__e( i18next.t('Show Attachments') ) +
'</a></li>\n<li><a href="#" class="js-show-chat-history-modal" data-toggle="modal" data-target="#modalChatHistoryView">' +
__e( i18next.t('Show Chat History') ) +
'</a></li>\n';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "edit_board",board_user_role_id: parseInt(board.board_user_role_id)})))) {;
__p += '\n<li><a href="#" class="js-additional-settings">' +
__e( i18next.t('Additional Settings') ) +
'</a></li>\n<li class="divider"></li>\n<li class="dropdown js-open-dropdown inner-dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-sm icon-warning-sign icon-type text-primary"></i>' +
__e( i18next.t('Close board') ) +
'</a>\n  <ul class="dropdown-menu arrow pull-right">\n\t<li class="js-dropdown-popup dropdown-popup">\n\t  <div class="clearfix text-center col-xs-12">\n\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Close board') ) +
'</strong></span><a class="js-close-sub-popover pull-right" href="#"><i class="icon-remove"></i></a>\t\t\t\t\t\t\n\t  </div>\n\t  <div class="col-xs-12 divider"></div>\n\t  <div class="col-xs-12">\n\t\t<form class="normal col-xs-12" name="BoardCloseForm" id="BoardCloseForm">\n\t\t  <input id="inputBoardClose" name="is_closed" type="hidden" value="true">\n\t\t  <p>' +
__e( i18next.t('You can reopen the board by clicking the "Boards" menu from the header, selecting "View Closed Boards", finding the board and clicking "Reopen".') ) +
'</p>\n\t\t  <div class="submit">\n\t\t\t<input type="submit" value="' +
__e( i18next.t('Close') ) +
'" id="submitBoardClose" class="btn btn-primary js-close-board">\n\t\t  </div>\n\t\t</form>\n\t  </div>\n\t</li>\n  </ul>\n</li>\n';
 } ;


}
return __p
};

this["JST"]["templates/board_simple_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(board != null){ ;
__p += '\n<hr>\n<div class="panel">\n  ';
 if(!_.isEmpty(board.subscribers)){ var subscriber = board.subscribers.findWhere({ user_id: parseInt(authuser.user.id) }); } ;
__p += '\n  <div class="panel-body bg-warning">\n    <div class="clearfix">\n\t\t<h4 class="col-md-9 col-sm-8 col-xs-9 navbar-btn">\n\t\t\t<span class="show row navbar-btn">\n\t\t\t  ';
 if(!_.isEmpty(role_links.where({slug: "view_board"}))){ ;
__p += '\n\t\t\t  <a href="#/board/' +
__e( board.id ) +
'" title="' +
__e( board.attributes.name ) +
'" class="htruncate btn-block">\n\t\t\t  ';
 } ;
__p += '\n\t\t\t  ';
 if(board.attributes.organization_id > 0 && board.attributes.organization_id != null){ 
					var logo_path = "img/default-organization.png"; 
					if (!_.isUndefined(board.attributes.organization_logo_url) && board.attributes.organization_logo_url != null && board.attributes.organization_logo_url != '') {
						logo_path = board.showImage('Organization', board.attributes.organization_id, 'small_thumb' );
					}
			  ;
__p += '\n\t\t\t\t\t<img src="' +
__e( logo_path ) +
'" title="' +
__e(board.attributes.organization_name) +
'" alt="[Image: Organization]" class="pull-left navbar-btn" width="16" height="16" /> &nbsp;\n\t\t\t  ';
 } ;
__p += '\n\t\t\t   ' +
__e( board.attributes.name) +
'\n\t\t\t  ';
 if(!_.isEmpty(role_links.where({slug: "view_board"}))){ ;
__p += '\n\t\t\t  </a>\n\t\t\t  ';
 } ;
__p += '\n      \t\t</span>\n\t  \t</h4> \n\t\t<span class="pull-right dropdown h5">\n\t\t';
 if(board.attributes.board_visibility == 0) { ;
__p += '\n\t\t  <span title="' +
__e( i18next.t('Private') ) +
'" class="text-primary icon-lock col-lg-2"></span>\n\t\t  ';
 } else if(board.attributes.board_visibility == 1) { ;
__p += '\n\t\t  <span title="' +
__e( i18next.t('Organization') ) +
'" class="text-primary icon-group col-lg-2"></span>\n\t\t  ';
 } else if(board.attributes.board_visibility == 2) { ;
__p += '\n\t\t  <span title="' +
__e( i18next.t('Public') ) +
'" class="text-primary icon-circle col-lg-2"></span>\n\t\t  ';
 } ;
__p += '\n\t\t</span>\n\t  ';
 if(!_.isEmpty(role_links.where({slug: "starred_board"}))){ ;
__p += '\n      ';
 if(!_.isUndefined(starred_boards) && starred_boards.map( Number ).indexOf(board.attributes.id) != -1){ ;
__p += '\n      <a title="' +
__e( i18next.t('Unstar') ) +
'" href="#" class="pull-right js-star-board h5" name="unstar"><i class="icon-star text-primary"></i></a>\n      ';
 } else {;
__p += '\n      <a title="' +
__e( i18next.t('Star') ) +
'" href="#" class="pull-right js-star-board h5" name="star"><i class="icon-star-empty"></i></a>\n      ';
 } ;
__p += '\n      ';
 } ;
__p += '\n    </div>\n    <div class="js-board-inner-view"></div>\n\t<ul class="list-unstyled chart-block">\n\t';
 
	var style = '';			
	if (board.attributes.background_picture_url) {
		var background_picture_url = board.attributes.background_picture_url.replace("_XXXX.jpg", "_n.jpg");
		style = 'background:url(' + background_picture_url + ') 25% 25%; background-size: cover';
	} else if (board.attributes.background_pattern_url) {
		var background_pattern_url = board.attributes.background_pattern_url.replace("_XXXX.jpg", "_s.jpg");
		style = 'background: transparent url(' + background_pattern_url + ')  repeat scroll 0% 0%;';
	} else if (board.attributes.background_color){
		style = 'background:' + board.attributes.background_color;
	}
	;
__p += '\n\t\t<li class="list-group-item clearfix" style="' +
((__t = ( style )) == null ? '' : __t) +
'">\n\t\t\t';
 if(!_.isEmpty(board.attributes.music_name)){ ;
__p += '\n\t\t\t<div class="col-xs-push-0 pa well-sm board-music-bg"><i class="icon-music icon-light"></i></div>\n\t\t\t';
 } ;
__p += '\n\t\t\t<a class="show" href="#/board/' +
__e( board.id ) +
'">\n\t\t\t    <div id="doughnutChart" class="chart js-chart"></div>\n\t\t\t</a>\n\t\t</li>\n\t</ul>\n  </div>\n</div>\n';
 }else{ ;
__p += '\n<div class="alert alert-info">\n\t' +
((__t = ( message )) == null ? '' : __t) +
'\n</div>\n';
};


}
return __p
};

this["JST"]["templates/board_user_actions"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li>\n<div class="col-xs-12 clearfix text-center">\n\t<span class="pull-left" data-placement="bottom" title="' +
__e( user.attributes.full_name ) +
' (' +
__e( user.attributes.username ) +
')" data-toggle="tooltip">\n\t';
 if(!_.isEmpty(user.attributes.profile_picture_path)) { 
		var profile_picture_path = user.showImage('User', user.attributes.user_id, 'micro_thumb' );
	;
__p += '\n\t\t<img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(user.attributes.username ) +
']" title="' +
__e( user.attributes.full_name ) +
' (' +
__e(user.attributes.username ) +
')" class="img-rounded">\n\t';
 } else {;
__p += '\n\t\t<i class="avatar avatar-color-194 img-rounded">' +
__e( user.attributes.initials ) +
'</i>\n\t';
 } ;
__p += '</span>\n\t<span class="col-xs-8"><a class="js-user-profile" data-id="' +
__e( user.attributes.user_id ) +
'" title="' +
__e( user.attributes.full_name + '@' + user.attributes.username ) +
'" href="javascript:void(0)"><strong>' +
__e( user.attributes.full_name ) +
'</strong> @' +
__e( user.attributes.username ) +
'</a></span>\n\t\t<span class="">\n\t\t\t<a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\n\t\t</span>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<ul class="list-unstyled dropdown-menu dropdown-list show">\n\t\t';
 if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(user.collection.board.acl_links.where({slug: 'edit_board_user', board_user_role_id: parseInt(user.collection.board.board_user_role_id)})))) { ;
__p += '\n\t\t<li class="dropdown"> \n\t\t\t<a href="#" data-toggle="dropdown" class="dropdown-toggle js-show-dropdown"> ' +
__e( i18next.t('Change permissions') ) +
' (' +
__e( user.board_user_roles[parseInt(user.attributes.board_user_role_id) - 1].name ) +
')</a>\n\t\t\t<ul class="dropdown-menu dropdown-menu-right arrow arrow-right js-list-actions-response">\n\t\t\t\t<div class="clearfix text-center col-xs-12"> <span class="col-xs-10"><strong>' +
__e( i18next.t('Change permissions') ) +
'</strong></span><a href="#" class="js-close-popup pull-right"><i class="icon-remove "></i></a> </div>\n\t\t\t\t<div class="col-xs-12 divider"></div>\n\t\t\t\t<div class="col-xs-12">\n\t\t\t\t  <ul class="list-unstyled">\n\t\t\t\t  ';
 _.each(user.board_user_roles, function(board_user_role){;
__p += '\n\t\t\t\t\t\t\t<li> <a href="#" data-board_user_role_id="' +
__e( board_user_role.id ) +
'" class="js-edit-board-member-permission"> <span class="show text-primary">\n\t\t\t\t\t\t\t' +
__e( board_user_role.name ) +
'\n\t\t\t\t\t\t\t';
 if(board_user_role.id == user.attributes.board_user_role_id){;
__p += '<i class="icon-check well-sm"></i>';
};
__p += '\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t</span> <span class="text-muted">' +
__e( board_user_role.description ) +
'</span> </a> </li>\n\t\t\t\t\t\t\t<li class="divider"></li>\n\t\t\t\t  ';
 }); ;
__p += '\n\t\t\t\t  </ul>\n\t\t\t\t</div>\n\t\t\t</ul>\n\t\t</li>\n\t\t';
 } ;
__p += '\n\t\t<li>\n\t\t\t';
 var title = i18next.t("View member's board activity"); ;
__p += '\n\t\t\t<a href="#" title="' +
__e( title ) +
'" data-user-id="' +
__e( user.attributes.user_id ) +
'" class="js-view-user-activities">\n\t\t\t\t<span>' +
__e( i18next.t("View member's board activity") ) +
'</span>\n\t\t\t</a>\n\t\t</li>\n\t\t';
 if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(user.collection.board.acl_links.where({slug: 'remove_board_user', board_user_role_id: parseInt(user.collection.board.board_user_role_id)})))) { ;
__p += '\n\t\t\t<li><a href="#" title="';
if(parseInt(authuser.user.id) != user.attributes.user_id ){;
__p +=
__e( i18next.t('Remove from board') );
}else{;
__p +=
__e( i18next.t('Leave from board') );
};
__p += '" class="js-show-confirm-delete-board-member">';
 if(parseInt(authuser.user.id) != user.attributes.user_id ){;
__p +=
__e( i18next.t('Remove from board') );
}else{;
__p +=
__e( i18next.t('Leave from board') );
};
__p += '</a></li>\n\t\t';
 } ;
__p += '\n\t\t\n\t</ul>\n</div>\n\n<li>';

}
return __p
};

this["JST"]["templates/board_user_activity"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12"><span class="col-xs-10"><strong>' +
__e( i18next.t('Member Activities') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a></div><div class="col-xs-12 divider"></div><div class="col-xs-12 member-modal js-pre-scrollable vertical-scrollbar"><ul class="list-unstyled list-inline"><li>' +
__e( i18next.t('User activities......') ) +
'</li></ul></div>';

}
return __p
};

this["JST"]["templates/board_user_remove_confirm"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<li>\n\t<div class="col-xs-12">\n\t\t<h4>' +
__e( i18next.t('Remove Member') ) +
'?\n\t\t\t<span class="pull-right">\n\t\t\t\t<a class="js-close-popover" href="#"><i class="icon-remove"></i></a>\n\t\t\t</span>\n\t\t</h4>\n\t\t<hr>\n\t</div>\n\t<div class="col-xs-12">\n\t\t<form class="normal" name="BoardUserForm" id="BoardUserForm">\n\t\t\t<div class="h5">' +
__e( i18next.t('Are you sure you want to do this action') ) +
'?</div>\n\t\t\t<ul class="dropdown-menu dropdown-list show">\n\t\t\t\t<li>\n\t\t\t\t\t<a class="js-delete-board-member" data-board_user_id="' +
__e( board_user.attributes.id ) +
'" href="#">\n\t\t\t\t\t \n\t\t\t\t\t ' +
__e( i18next.t('Remove %s from %s Boards? The member will be removed from all cards on this board.', { postProcess: 'sprintf', sprintf: [board_user.attributes.username,board_user.attributes.board_name]}) ) +
'\n\t\t\t\t </li>\n\t\t\t</ul>\n\t\t</form>\n\t</div>\n</li>';

}
return __p
};

this["JST"]["templates/board_users_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<a title="' +
__e( user.attributes.full_name ) +
' (' +
__e( user.attributes.username ) +
')" href="#" class="dropdown-toggle js-show-board-user-action pull-left" data-toggle="dropdown"> <span data-placement="bottom" title="' +
__e( user.attributes.full_name ) +
' (' +
__e(user.attributes.username ) +
')" data-toggle="tooltip" class="col-xs-12 btn-block navbar-btn">\t\t\t\t\n\t';
 if(!_.isEmpty(user.attributes.profile_picture_path)) { 
		var profile_picture_path = user.showImage('User', user.attributes.user_id, 'small_thumb' );
	;
__p += '\n\t\t<img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(user.attributes.full_name ) +
']" title="' +
__e(user.attributes.full_name ) +
' (' +
__e(user.attributes.username ) +
')" class="img-rounded img-responsive avatar">\n\t';
 } else {;
__p += '\n\t\t<i class="avatar avatar-color-194 img-rounded">' +
__e( user.attributes.initials ) +
'</i>\t\t\t\t\t\t\t\t\t\n\t';
 } ;
__p += '\n\t';
 if(user.board_user_roles[user.attributes.board_user_role_id - 1].id === 1){ ;
__p += '\n\t\t<span class="name-block col-xs-1 label btn-xs col-xs-push-0">' +
__e( i18next.t('Owner') ) +
'</span>\n\t';
 } ;
__p += '\n</span></a>\n\t\t<ul class="dropdown-menu dropdown-menu-left arrow arrow-left">\n\t\t\t<li class="js-show-board-user-action-response js-dropdown-popup dropdown-popup">\n\t\t\t\t\n\t\t\t</li>\n\t\t</ul>';

}
return __p
};

this["JST"]["templates/board_visibility"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li class="col-xs-12"><input class="js-input-board-visibility" name="board_visibility" type="hidden" value="' +
__e( board.attributes.board_visibility ) +
'">\n<input class="js-input-board-organization-id" name="organization_id" type="hidden" value="' +
__e( board.attributes.organization_id ) +
'">\n<a href="#" name="private" class="btn-default show row small well-xs js-select-visibility"><span class="show text-primary col-xs-12 navbar-btn h5">' +
__e( i18next.t('Private') ) +
'\n  ';
 if(board.attributes.board_visibility == 0){ ;
__p += '\n  <i class="icon-check"></i>\n  ';
};
__p += '\n  </span><span class="col-xs-12 navbar-btn">' +
__e( i18next.t('This board is private. Only people added to the board can view and edit it.') ) +
'</span></a></li>\n  <li class="divider col-xs-12"></li>\n<li class="col-xs-12"><a href="#" name="org" class="show row small well-xs js-select-visibility disabled"><span class="show text-primary col-xs-12 navbar-btn h5">' +
__e( i18next.t('Organization') ) +
'\n  ';
 if(board.attributes.board_visibility == 1){ ;
__p += '\n  <i class="icon-check"></i>\n  ';
};
__p += '\n  </span> <span class="col-xs-12 navbar-btn">' +
__e( i18next.t('This board is visible to members of the organization. Only people added to the board can edit.') ) +
' <span class="error">' +
__e( i18next.t('The board must be added to an org to enable this.') ) +
'</span></span></a></li>\n  <li class="divider col-xs-12"></li>\n<li class="col-xs-12"><a href="#" name="public" class="show row small well-xs js-select-visibility"><span class="show text-primary col-xs-12 navbar-btn h5">' +
__e( i18next.t('Public') ) +
'\n  ';
 if(board.attributes.board_visibility == 2){ ;
__p += '\n  <i class="icon-check"></i>\n  ';
};
__p += '\n  </span> <span class="col-xs-12 navbar-btn">' +
__e( i18next.t("This board is public. It's visible to anyone with the link and will show up in search engines like Google. Only people added to the board can edit.") ) +
'</span></a></li>\n';

}
return __p
};

this["JST"]["templates/card"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="panel-body">\n  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.board.acl_links.where({slug: "view_card_labels", board_user_role_id: parseInt(card.board_user_role_id)})))) {  ;
__p += '\n  <div class="clearfix js-card-label-section-' +
__e( card.attributes.id ) +
'">\n  ';

  	card.labels.each(function(label) {
            if (!_.isUndefined(label) && label.attributes.name !== "") { ;
__p += '\n\t\t\t<span class="cur"><i style="color:#' +
__e( converter.colorCode(''+label.attributes.name).substring(0, 6) ) +
';" data-toggle="tooltip" data-container="body" data-placement="top" data-original-title="' +
__e( label.attributes.name ) +
'" title="' +
__e( label.attributes.name ) +
'" class="' +
((__t = ( LABEL_ICON )) == null ? '' : __t) +
' cur"></i></span>\n               \n   ';
         }
        });;
__p += ' \n  \n  \n  </div>\n ';
  } ;
__p += ' \n <div class="clearfix">\n  ';
 if(!_.isEmpty(card.attachments) && card.attachments.length > 0 && !_.isEmpty(card.attachments.at(0).attributes.name) && card.attachments.at(0).attributes.name.toLowerCase().match(/\.(jpg|jpeg|png|gif)$/)){ ;
__p += '\n\t  <div class="clearfix js-card-attachment-image navbar-btn ';
 if(!_.isEmpty(card.collection) && !card.list.collection.board.attributes.is_show_image_front_of_card){ ;
__p += ' hide ';
 } ;
__p += '">\n\t\t';

			var img_src = card.showImage('CardAttachment',  card.attachments.at(0).attributes.id, 'large_thumb' );
		;
__p += '\n\t\t<img class="img-responsive center-block" src="' +
((__t = ( img_src )) == null ? '' : __t) +
'"/>\n\t  </div>\n\t';
 } ;
__p += ' \n  <a href="#" title="' +
__e( card.attributes.name ) +
'">' +
__e( card.attributes.name ) +
'</a>\n  </div>\n  <div class="pull-left navbar-btn">\n  <ul class="list-unstyled list-inline text-muted clearfix">\n  \t';

		if(!_.isUndefined(authuser) && !_.isUndefined(authuser.user)){
			var cards_subscribers = card.cards_subscribers.where({
				is_subscribed: 1,
				user_id: parseInt(authuser.user.id) 
			});
		}
	;
__p += '\n\t';
 if(!_.isUndefined(cards_subscribers) && !_.isEmpty(cards_subscribers)){ ;
__p += '\n\t\t<li><small><span class="icon-eye-open"></span></small></li>\n\t';
 } ;
__p += ' \n\t';
 if(card.card_voters.length > 0){ ;
__p += '\n\t<li><small  title="' +
__e( i18next.t('{{count}} Vote', {count: card.card_voters.length}) ) +
' "><span class="icon-thumbs-up"></span><span>' +
__e( card.card_voters.length ) +
'</span></small></li>\n\t';
 } ;
__p += '\n\t';
 
	if(card.attributes.comment_count > 0){ 
	;
__p += '\n\t<li><small title="' +
__e( i18next.t('{{count}} Comment', {count: card.attributes.comment_count}) ) +
' " ><span class="icon-comment"></span><span>' +
__e( card.attributes.comment_count ) +
'</span></small></li>\n\t';
 } ;
__p += '\n\t';
 if(!_.isEmpty(card.attributes.description)){ ;
__p += '\n\t<li><small title="' +
__e( i18next.t('Description') ) +
'"><span class="icon-align-left"></span><span></span></small></li>\n\t';
 } ;
__p += '\n\t';
 if(card.attributes.checklist_item_count > 0){ ;
__p += '\n\t\t<li><small title="' +
__e( i18next.t('%s checklist completed out of %s', { postProcess: 'sprintf', sprintf: [card.attributes.checklist_item_completed_count, card.attributes.checklist_item_count]}) ) +
' ">';
 if(card.attributes.checklist_item_completed_count == card.attributes.checklist_item_count) { ;
__p += '<div class="label label-success"> ';
 } ;
__p += '<span class="icon-list-ul"></span><span>' +
__e( card.attributes.checklist_item_completed_count ) +
'/' +
__e( card.attributes.checklist_item_count ) +
'</span>';
 if(card.attributes.checklist_item_completed_count == card.attributes.checklist_item_count) { ;
__p += '</div>';
 } ;
__p += '</small></li>\n\t';
 } ;
__p += ' \n\t';
 if(card.attributes.due_date > 0){ ;
__p += '\n\t\t<li><small title="' +
__e( i18next.t('Due Date') ) +
'"><span class="icon-time"></span><span>' +
__e( card.attributes.due_date ) +
'</span></small></li>\n\t';
 } ;
__p += ' \n\t';
 if(!_.isEmpty(card.attachments) && card.attachments.length > 0){ ;
__p += '\n\t<li>\n\t\t<small title="' +
__e( i18next.t('{{count}} Attachment', {count: card.attachments.length}) ) +
' ">\n\t\t\t<span class="icon-paper-clip"></span>\n\t\t\t<span>\n\t\t\t' +
__e( card.attachments.length ) +
'\n\t\t\t</span>\n\t\t</small>\n\t</li>\n\t';
 } ;
__p += '  \n\t';
 if(!_.isUndefined(card.id) && (_.isUndefined(card.attributes.is_offline) || card.attributes.is_offline == false)){ ;
__p += '\n\t<li class="pull-right card-id"><strong>#' +
__e( card.id ) +
'</strong></li>\n\t';
};
__p += '\n\t';
 if(!_.isEmpty(card.attributes.due_date) && card.attributes.due_date != 'NULL'){
		var date_time = card.attributes.due_date.split('T');
		date_time = date_time[0].split(' ');
	;
__p += '\n\t';

		var today = new Date();
		card_due_date = card.attributes.due_date.split('T');
		var due_date = new Date(card_due_date[0]);
		var diff = Math.floor(due_date.getTime() - today.getTime());
		var day = 1000 * 60 * 60 * 24;
		var days = Math.floor(diff / day);
		if (days < -1) {
			label = 'label-past';
		} else if (days == -1) {
			label = 'label-present';
		} else if (days > -1) {
			label = 'label-future';
		}
	;
__p += '\n\t<li><small title=" ' +
__e( i18next.t('Due Date') ) +
'"><span class="label ' +
__e( label ) +
'">' +
((__t = ( dateFormat(date_time[0], 'mediumDate')  )) == null ? '' : __t) +
'</span></small></li>\n\t';
 } ;
__p += '\n\t</ul>\n\t</div>\n\t<div class="clearfix pull-right">\n\t\t<ul class="list-unstyled list-inline text-muted clearfix">\n\t\t';

			card.users.each(function(card_user) {
				if (!_.isUndefined(card_user)) {
		;
__p += '\n\t\t\t\t\t<li class="pull-right js-tooltip navbar-btn" data-container="body" data-placement="bottom" title="' +
__e(card_user.attributes.full_name ) +
' (' +
__e(card_user.attributes.username ) +
')" data-toggle="tooltip">\n\t\t\t\t\t\t';
 if(!_.isEmpty(card_user.attributes.profile_picture_path)) { 
							var profile_picture_path = card.showImage('User', card_user.attributes.user_id, 'small_thumb' );
						;
__p += '\n\t\t\t\t\t\t\t<img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(card_user.attributes.username ) +
']" title="' +
__e(card_user.attributes.full_name ) +
' (' +
__e(card_user.attributes.username ) +
')" class="img-rounded img-responsive avatar">\n\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t<i class="avatar avatar-color-194 img-rounded">' +
__e( card_user.attributes.initials ) +
'</i>\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t</li>\n\t\t';
		
				}
			});
		;
__p += '\n\t\t</ul>\n\t</div>\n</div>';

}
return __p
};

this["JST"]["templates/card_actions"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li class="text-center"><strong>' +
__e( i18next.t('Options') ) +
'</strong></li><li class="divider"></li>';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "add_card_user",board_user_role_id: parseInt(card.board_user_role_id)})))) { ;
__p += '<li><a class="js-show-add-member-form" title="' +
__e( i18next.t('Members') ) +
'" href="#">' +
__e( i18next.t('Members') ) +
'</a></li>';
 } ;

 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "add_labels",board_user_role_id: parseInt(card.board_user_role_id)})))) { ;
__p += '<li><a class="js-show-card-label-form" title="' +
__e( i18next.t('Labels') ) +
'" href="#">' +
__e( i18next.t('Labels') ) +
'</a></li>';
 } ;
__p += '<li><a class="js-show-card-position-form" title="' +
__e( i18next.t('Position') ) +
'" href="#">' +
__e( i18next.t('Position') ) +
'</a></li>';

}
return __p
};

this["JST"]["templates/card_add"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="js-lables-list"></div>\n<form method="post" role="form" class="form-horizontal js-cardAddForm col-xs-12" name="cardAddForm">\n\t<input type="hidden" name="board_id" value="' +
__e( model.attributes.board_id ) +
'">\n\t<input type="hidden" name="list_id" class="js-card-add-list" value="' +
__e( model.attributes.list_id ) +
'">\n\t<input type="hidden" name="user_ids" class="js-card-user-ids" value="">\n\t<input type="hidden" name="card_labels" class="js-card-add-labels" value="">\n\t<input type="hidden" name="position" class="js-card-add-position" value="">\n\t<div class="form-group">\n\t\t<textarea placeholder=" ' +
__e( i18next.t('Add a card') ) +
'" rows="3" id="AddCard" class="form-control" name="name" required>' +
__e( name ) +
'</textarea> \n\t</div>\n\t<div class="row">     \n\t\t<div class="pull-left">\n\t\t\t<input type="submit" value="' +
__e( i18next.t('Add') ) +
'" class="btn btn-primary js-cardAddForm-btn">\n\t\t</div>\n\t\t<ul class="list-unstyled pull-right">\n\t\t\t<li class="pull-left">\n\t\t\t\t<a title="' +
__e( i18next.t('Cancel') ) +
'" href="#" class="btn btn-link js-cancel-card-add"><i class="icon-remove text-muted"></i></a>\n\t\t\t</li>\n\t\t\t<li class="pull-right dropdown inner-dropdown">\n\t\t\t\t<a title="' +
__e( i18next.t('Options') ) +
'" data-toggle="dropdown" class="btn btn-link btn-block dropdown-toggle js-show-card-action-list" href="#"><i class="icon-cog text-muted"></i></a>\n\t\t\t</li>\n\t\t</ul>\n\t</div>\n</form>\n';

}
return __p
};

this["JST"]["templates/card_attachment"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(_.isEmpty(attachment.attributes.link) && !_.isEmpty(attachment.attributes.name)){ ;
__p += '\n\t<a target="_blank" href="' +
((__t = ( attachment.downloadLink('download', attachment.attributes.id) )) == null ? '' : __t) +
'?view" class="pull-left navbar-btn img-thumbnail">\n\t';
 if(attachment.attributes.name.toLowerCase().match(/\.(jpg|jpeg|png|gif)$/)){ 
		var picture_path = attachment.showImage('CardAttachment', attachment.attributes.id, 'large_thumb' );
	;
__p += '\n\t\t<img src="' +
((__t = ( picture_path )) == null ? '' : __t) +
'">\n\t';
 } else {
		var extension = attachment.attributes.name.split('.');
	;
__p += '\n\t\t<p class="thumb-img">' +
__e( extension[extension.length - 1].toUpperCase() ) +
'</p>\n\t';
 } ;
__p += '\n\t</a>\n';
 } else if(!_.isEmpty(attachment.attributes.link)){ ;
__p += '\n\t<a target="_blank" href="' +
((__t = ( attachment.attributes.link )) == null ? '' : __t) +
'" title="' +
__e( attachment.attributes.link ) +
'" class="pull-left navbar-btn img-thumbnail">\n\t\t<p class="thumb-img">\n\t\t';
 if (attachment.attributes.link.indexOf("dropbox.com") > -1) {;
__p += '\n\t\t\t<i class="icon-dropbox"></i>\n\t\t';
 } else if(attachment.attributes.link.indexOf("docs.google.com") > -1){ ;
__p += '\n\t\t\t<i class="icon-cloud"></i>\n\t\t';
 } else if(attachment.attributes.link.indexOf("github.com") > -1){ ;
__p += '\n\t\t\t<i class="icon-github"></i>\n\t\t';
 } else if(!_.isEmpty(attachment.attributes.name) && !_.isEmpty(attachment.attributes.link)) {  var extension = attachment.attributes.name.split('.'); ;

 if(!_.isUndefined(extension) && extension.length > 1) { ;

 if(attachment.attributes.name.toLowerCase().match(/\.(jpg|jpeg|png|gif)$/)){ ;
__p +=
__e( extension[extension.length - 1].toUpperCase() );
 } else { ;
__p += 'LINK';
 } } ;

 };
__p += '\n\t\t</p>\n\t</a>\n';
 } ;
__p += '\n<div class="clearfix btn-block col-xs-12">\n';
 if(_.isEmpty(attachment.attributes.link) && !_.isEmpty(attachment.attributes.name)){ ;
__p += '\n\t\t<a target="_blank" href="' +
((__t = ( attachment.downloadLink('download', attachment.attributes.id) )) == null ? '' : __t) +
'" title="' +
__e( attachment.attributes.name ) +
'"><span class="show htruncate col-xs-11 nav">' +
__e( attachment.attributes.name ) +
'</span><span class="show btn-block col-xs-12">' +
__e( i18next.t('Added') ) +
' <small class="text-muted"><abbr class="timeago" title="' +
__e( attachment.attributes.created ) +
'">' +
__e( attachment.attributes.created ) +
'</abbr></small></span></a>\n';
 } else if(!_.isEmpty(attachment.attributes.link)){ ;
__p += '\n\t\t<a target="_blank" href="' +
((__t = ( attachment.attributes.link )) == null ? '' : __t) +
'" title="' +
__e( attachment.attributes.link ) +
'">\n\t\t\t<span class="show htruncate col-xs-11 nav">' +
__e( attachment.attributes.link ) +
'</span><span class="show btn-block col-xs-12">' +
__e( i18next.t('Added') ) +
' <small class="text-muted"><abbr class="timeago" title="' +
__e( attachment.attributes.created ) +
'">' +
__e( attachment.attributes.created ) +
'</abbr></small></span>\n\t\t</a>\n';
 } ;
__p += '\n';
if(!_.isUndefined(authuser.user)) {;
__p += '\n\t<div class="btn-toolbar navbar-btn">\n\t\t<div class="btn-group btn-group-xs navbar-btn">\n\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(attachment.board.acl_links.where({slug: "download_attachment_card", board_user_role_id: parseInt(attachment.board.board_user_role_id)})))) {
			;
__p += '\n\t\t\t<div class="btn btn-primary">\t\n\t\t\t';

			if(_.isEmpty(attachment.attributes.link)) {;
__p += ' \n\t\t\t';
 
				var download_link = attachment.downloadLink('download', attachment.attributes.id);
			;
__p += '\n\t\t\t\t<a target="_blank" href="' +
((__t = ( download_link )) == null ? '' : __t) +
'" title="' +
__e( i18next.t('Download') ) +
'">\n\t\t\t\t<i class="icon-arrow-down cur icon-light"></i></a>\n\t\t\t';
 } else {;
__p += '\n\t\t\t\t';
 var link_title = 'Open in New Tab'; ;
__p += '\n\t\t\t\t   ';
 if (attachment.attributes.link.indexOf("dropbox.com") > -1) {;
__p += '\n\t\t\t\t\t';
 link_title = 'Open in Dropbox'; ;
__p += '\n\t\t\t\t';
 } else if(attachment.attributes.link.indexOf("docs.google.com") > -1){ ;
__p += '\n\t\t\t\t\t';
 link_title = 'Open in Google Drive'; ;
__p += '\n\t\t\t\t';
 } else if(attachment.attributes.link.indexOf("github.com") > -1){ ;
__p += '\n\t\t\t\t\t';
 link_title = 'Open in Github'; ;
__p += '\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t<a target="_blank" href="' +
((__t = ( attachment.attributes.link )) == null ? '' : __t) +
'" title="' +
__e( link_title ) +
'">\n\t\t\t\t<i class="icon-external-link cur icon-light"></i></a>\n\t\t\t';
 } ;
__p += '\n\t\t\t</div>\n\t\t\t';
 } ;
__p += '\n\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(attachment.board.acl_links.where({slug: "remove_card_attachment", board_user_role_id: parseInt(attachment.board.board_user_role_id)})))) { ;
__p += ' \n\t\t\t\t\t<div class="dropdown pull-left">\n\t\t\t\t\t\t<a href="#" title="' +
__e( i18next.t('Delete') ) +
'" class="btn btn-default btn-xs js-show-confirm-delete-attachment dropdown-toggle" data-toggle="dropdown">\n\t\t\t\t\t\t\t<i class="icon-remove cur"></i>\n\t\t\t\t\t\t</a>\n\t\t\t\t\t\t<ul class="dropdown-menu arrow list-unstyled">\n\t\t\t\t\t\t\t<li class="js-dropdown-popup js-attachment-confirm-respons-' +
__e( attachment.id ) +
'"></li>\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t</div>\n\t\t\t\t';
 } ;
__p += '\n\t\t</div>\n\t</div>\n';
 } ;
__p += '\n</div>';

}
return __p
};

this["JST"]["templates/card_checklist"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="list-group-item-heading clearfix js-checklist-head">\n\t<h3 class="pull-left col-xs-9">\n\t\t<span class="pull-left row"><i class="icon-list text-muted lead"></i></span>\n\t\t<span class="';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(checklist.board_users.board.acl_links.where({slug: 'edit_checklist',board_user_role_id: parseInt(checklist.board_user_role_id)})))){ ;
__p += 'js-show-checklist-edit-form';
 } ;
__p += ' col-sm-12">\n\t\t\t<a href="#" title="' +
__e( checklist.get('name') ) +
'" class="';
 if(_.isUndefined(authuser.user) || (authuser.user.role_id == 1 || _.isEmpty(checklist.board_users.board.acl_links.where({slug: 'edit_checklist',board_user_role_id: parseInt(checklist.board_user_role_id)})))){;
__p += ' js-no-action';
};
__p += '">' +
__e( checklist.get('name') ) +
'</a>\n\t\t</span>\n\t</h3>\n\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(checklist.board_users.board.acl_links.where({slug: "delete_checklist",board_user_role_id: parseInt(checklist.board_user_role_id)})))){ ;
__p += '\n\t<div class="navbar-right dropdown h4">\n\t\t<a class="btn btn-link dropdown-toggle js-show-checklist-actions" role="button" data-toggle="dropdown" title=" ' +
__e( i18next.t('Checklist') ) +
'" href="#"> \n\t\t\t<span><i class="icon-chevron-sign-down text-primary"></i></span>\n\t\t</a>\n\t\t<ul class="dropdown-menu arrow dropdown-menu-left" id="js-checklist-confirm-response-' +
__e( checklist.get('id') ) +
'">\n\t\t\t<li class="clearfix">\n\t\t\t\t<div class="clearfix text-center col-xs-12">\n\t\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t("Checklist") ) +
'</strong></span>\n\t\t\t\t\t<a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a>\n\t\t\t\t</div>\n\t\t\t</li>\n\t\t\t<li class="clearfix"><div class="col-xs-12 divider"></div></li>\n\t\t\t<li class="clearfix" id="js-checklist-actions-response-' +
__e( checklist.get('id') ) +
'"></li>\n\t\t</ul>\n\t</div>\n\t';
 } ;
__p += '\n</div>\n<div class="list-group-item-text clearfix">\n';
 
	var percentage = ((parseInt(checklist.get('checklist_item_completed_count')) / parseInt(checklist.get('checklist_item_count'))) * 100);
 ;
__p += '\n ';
 
 	if(isNaN(percentage)){ 
		percentage_val = 0;
	} else {
		percentage_val = Math.round(percentage, 2);
	}
 ;
__p += '\n <div class="clearfix">\n \t<span class="pull-left" id="js-checklist-progress-percent-' +
__e( checklist.get('id') ) +
'">\n\t\t' +
((__t = ( percentage_val)) == null ? '' : __t) +
'% &nbsp;</span><div class="progress"><div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" id="js-checklist-progress-bar-' +
__e( checklist.get('id') ) +
'" style="width:' +
((__t = ( Math.round(percentage, 2) )) == null ? '' : __t) +
'%"><span class="sr-only">' +
((__t = ( Math.round(percentage, 2) )) == null ? '' : __t) +
'%</span></div></div></div> <div  id="js-checklist-items-' +
__e( checklist.get('id') ) +
'" class="js-checklist-items-sorting checklist-items-sorting" data-checklist_id="' +
__e( checklist.get('id') ) +
'"> </div></div>';

}
return __p
};

this["JST"]["templates/card_checklist_item"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="form-group list-group-item-text" data-checklist-id="' +
__e( checklist_item.get('id') ) +
'">\n\t<div class="checkbox list-group-item-text">\n\t\t<input id="checklist' +
__e( checklist_item.get('id') ) +
'" type="checkbox" class="hide ';
 if(!_.isUndefined(authuser.user)){ if(parseInt(checklist_item.get('is_completed')) === 1){ ;
__p += ' js-markas-incomplete ';
 } else{;
__p += ' js-markas-completed ';
 } } ;
__p += '" ';
 if(parseInt(checklist_item.get('is_completed')) === 1){ ;
__p += 'checked';
 } ;
__p += ' ';
 if(_.isUndefined(authuser.user)){;
__p += ' disabled';
};
__p += ' >\n\t\t<label for="checklist' +
__e( checklist_item.get('id') ) +
'" class="pull-left js-checklist-item-head">\n\t\t</label>\n\t\t<div class="col-xs-11 row">\n\t\t\t<span id="js-checklist-item-' +
__e( checklist_item.get('id') ) +
'" class="';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(checklist_item.board_users.board.acl_links.where({slug: 'edit_checklist_item',board_user_role_id: parseInt(checklist_item.board_user_role_id)})))){ ;
__p += 'js-show-item-edit-form';
 }else{ ;
__p += 'js-no-action';
};
__p += '  ';
 if(parseInt(checklist_item.get('is_completed')) === 1){ ;
__p += ' strike-through-text ';
 } ;
__p += '" >' +
((__t = ( converter.makeHtml(_.escape(checklist_item.get('name'))) )) == null ? '' : __t) +
'</span>\n\t\t</div>\n\t</div>\n</div>';

}
return __p
};

this["JST"]["templates/card_copy"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<li><div class="clearfix text-center col-xs-12"><a data-list-id="95" class="js-back-to-card-actions pull-left" href="#"><i class="icon-caret-left"></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t('Search for a card to copy') ) +
'</strong></span><a href="#" class="js-close-popup pull-right"><i class="icon-remove"></i></a></div></li><li class="col-xs-12 divider"></li><li><div class="col-xs-12"><div class="form-group"><input type="text" placeholder="' +
__e( i18next.t('Search for a card to copy') ) +
'" class="js-card-add-search form-control input-sm" title="' +
__e( i18next.t('Search for a card to copy') ) +
'"></div><div class="js-card-add-search-response"><ul class="list-unstyled js-card-add-search-response"></ul></div></div></li>';

}
return __p
};

this["JST"]["templates/card_duedate_from"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {


	var currentdate = new Date();
	var date = currentdate.getFullYear() + '-' + (((currentdate.getMonth()+1)<10)? '0'+ (currentdate.getMonth()+1) : (currentdate.getMonth()+1)) + '-' + ((currentdate.getDate()<10)? '0' + currentdate.getDate() : currentdate.getDate());
	var time = currentdate.getHours() + ':' + (currentdate.getMinutes()<10?'0':'') + currentdate.getMinutes() + ':' + (currentdate.getSeconds()<10?'0':'') + currentdate.getSeconds();
	if (!_.isUndefined(this.model.attributes.due_date) && this.model.attributes.due_date !== null && this.model.attributes.due_date !== 'NULL') {
		var date_time = this.model.attributes.due_date.replace('T',' ');
		date_time = date_time.split(' ');
		date = date_time[0];
		time = date_time[1];
	}
;
__p += '\n<div class="form-group">\n\t<div class="col-xs-6">\n\t\t<label>' +
__e( i18next.t('Date') ) +
'\n\t\t</label>\n\t\t<input type="text" class="form-control input-sm js-card-duedate-edit-' +
((__t = (card.attributes.id)) == null ? '' : __t) +
'" name="due_date" data-format="yyyy-MM-dd" value="' +
((__t = ( date )) == null ? '' : __t) +
'" required>\n\t</div>\n\t<div class="col-xs-6">\n\t\t<label>' +
__e( i18next.t('Time') ) +
'\n\t\t</label>\n\t\t<input type="text" class="form-control input-sm js-card-duetime-edit-' +
((__t = (card.attributes.id)) == null ? '' : __t) +
'" name="due_time" data-format="hh:mm:ss" value="' +
((__t = ( time )) == null ? '' : __t) +
'" required>\n\t</div>\n</div>\n<div class="form-group">\n\t<div class="col-xs-6">\n\t\t<label for="save" class="sr-only">' +
__e( i18next.t('Save') ) +
'\n\t\t</label>\n\t\t<input type="submit" value="' +
__e( i18next.t('Save') ) +
'" id="save" class="btn btn-primary" id="submitCardDueDateEditForm">\n\t</div>\n\t';
 if(!_.isEmpty(card.attributes.due_date) && card.attributes.due_date != 'NULL') { ;
__p += '\n\t<div class="col-xs-6">\n\t\t<label for="remove" class="sr-only">' +
__e( i18next.t('Remove') ) +
'\n\t\t</label>\n\t\t<input type="reset" value="' +
__e( i18next.t('Remove') ) +
'" class="btn btn-default js-remove-due-date">\n\t</div>\n\t';
 } ;
__p += '\n</div>';

}
return __p
};

this["JST"]["templates/card_label"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<span style="background:#' +
((__t = ( background )) == null ? '' : __t) +
';color:#ffffff" class="btn">' +
__e( label.get('name') ) +
'</span>';

}
return __p
};

this["JST"]["templates/card_label_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\n\t<span class="col-xs-10">\n\t\t<strong> ' +
__e( i18next.t('Labels') ) +
'</strong>\n\t</span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a></div><div class="col-xs-12 divider"></div><div class="col-xs-12"><form name="cardLabelAddForm" class="js-card-label-add-form"><div class="form-group"><input type="text" class="inputCardLabel" name="name" value="' +
__e(labels ) +
'" /><input type="hidden" class="inputHiddenCardLabel" name="hiddenName" value="' +
__e(labels ) +
'" /></div><div class="submit"><input type="submit" value="' +
__e( i18next.t('Save') ) +
'" class="btn btn-primary pull-left"></div></form></div>';

}
return __p
};

this["JST"]["templates/card_labels_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12"><a class="js-back-to-card-actions pull-left" href="#"><i class="icon-caret-left no-pad"></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t('Labels') ) +
'</strong></span><a class="js-close-sub-popover pull-right" href="#"><i class="icon-remove"></i></a></div><div class="col-xs-12 divider"></div><div class="col-xs-12"><div class=""><input type="text" class="js-card-label" name="labels"></div></div>';

}
return __p
};

this["JST"]["templates/card_list_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(card != null && !_.isEmpty(card)){ ;
__p += '\n<td>\n <ul class="unstyled  hide js-card-labels">\n</ul>\n<ul class="unstyled  js-card-users hide">\n</ul>\n<ul class="unstyled  js-card-due hide">\n <li></li>\n</ul>\n<div id="js-card-' +
__e( card.attributes.id ) +
'" class="js-show-modal-card-view panel cur">\n\t<div class="panel-body"> \n\t\t<ul class="list-inline navbar-btn clearfix">\n\t\t  <li class="col-md-1 col-xs-2"><span class="card-id">#' +
__e( card.attributes.id ) +
'</span></li>\n\t\t  <li class="col-md-4 col-xs-3">' +
__e( card.attributes.name ) +
'</li>\n\t\t  <li class="col-md-4 col-xs-3">' +
__e( card.list_name ) +
'</li>\n\t\t<li class="list-view">\n\t\t\t<ul class="list-inline">\n\t\t\t ';
 
				if(!_.isUndefined(authuser) && !_.isUndefined(authuser.user)){
				var cards_subscribers = card.cards_subscribers.where({ is_subscribed: 1, user_id: parseInt(authuser.user.id) }); 
				}
				if(!_.isUndefined(cards_subscribers) && cards_subscribers > 0){ ;
__p += '\n\t\t\t\t<li><small><span class="icon-eye-open"></span></small></li>';
 } ;
__p += '\n\t\t\t\t';
 if(card.attributes.card_voter_count > 0) { ;
__p += '<li title="' +
__e( i18next.t('{{count}}', {count: card.attributes.card_voter_count}) ) +
'" data-placement="bottom" data-toggle="tooltip"><small>' +
__e( card.attributes.card_voter_count ) +
'</small></li>';
 } else { ;
__p += '<li> <small>0</small></li>';
 } ;
__p += '\n\t\t\t\t';
 if(!_.isEmpty(card.attachments) && card.attachments.length > 0){ ;
__p += '<li title="' +
__e( i18next.t('{{count}}', {count: card.attachments.length}) ) +
' "" data-placement="bottom" data-toggle="tooltip"><small>' +
__e( card.attachments.length ) +
'</small></li>';
 } else { ;
__p += '<li> <small>0</small></li>';
 } ;
__p += '\n\t\t\t\t';
 if(card.attributes.comment_count > 0){ ;
__p += '<li title="' +
__e( i18next.t('{{count}}', {count: card.attributes.comment_count}) ) +
' "" data-placement="bottom" data-toggle="tooltip"><small>' +
__e( card.attributes.comment_count ) +
'</small></li>';
 } else { ;
__p += '<li> <small>0</small></li>';
 } ;
__p += '\n\t\t\t\t';
 if(card.attributes.checklist_item_count > 0){ ;
__p += '<li title="' +
__e( i18next.t('%s checklist completed out of %s', { postProcess: 'sprintf', sprintf: [card.attributes.checklist_item_completed_count,card.attributes.checklist_item_count]}) ) +
' "" data-placement="bottom" data-toggle="tooltip"><small>\n\t\t\t\t\t';
 if(card.attributes.checklist_item_completed_count == card.attributes.checklist_item_count) { ;
__p += '\n\t\t\t\t\t\t<span class="label label-success">' +
__e( card.attributes.checklist_item_completed_count ) +
'/' +
__e( card.attributes.checklist_item_count ) +
'</span>\n\t\t\t\t\t';
 } else { ;
__p += '\n\t\t\t\t\t\t<span class="label label-danger">' +
__e( card.attributes.checklist_item_completed_count ) +
'/' +
__e( card.attributes.checklist_item_count ) +
'</span>\n\t\t\t\t\t';
 } ;
__p += '\t\n\t\t\t\t</small></li>';
 } else { ;
__p += '<li><small>-</small></li>';
 } ;
__p += '\n\t\t\t\t\n\t\t\t\t';
 if(!_.isEmpty(card.attributes.due_date) && card.attributes.due_date != 'NULL'){ ;

card_due_date = card.attributes.due_date;var today = new Date();var last_day = new Date(today.getFullYear(), today.getMonth() + 1, 0);var next_month_last_day = new Date(today.getFullYear(), today.getMonth() + 2, 0);var due_date = new Date(card_due_date);var diff = Math.floor(due_date.getTime() - today.getTime());var day = 1000 * 60 * 60 * 24;var days = Math.floor(diff / day);var months = Math.floor((days + (today.getDate() + 1)) / next_month_last_day.getDate());var years = Math.floor(months / 12);var week = days - (6 - (today.getDay()));var label = 'label-default';if (years < 0 || months < 0 || days <= -1) {label = 'label-danger';};
__p += '<li title="' +
__e( i18next.t('Due Date') ) +
'" data-placement="bottom" data-toggle="tooltip"><small><span class="label ' +
__e( label ) +
'">';
 var date_time = card.attributes.due_date.split('T'); date_time = date_time[0].split(' '); ;
__p +=
((__t = ( dateFormat(date_time[0], 'mediumDate')  )) == null ? '' : __t) +
'</span></small></li>';
 } ;
__p += '\n\t\t\t</ul>\n\t\t</li>\n\t\t</ul>\n\t</div>\n</div>\n</td>\n';
 } else { ;
__p += '<td colspan="4"  class="text-center alert alert-info">' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('cards')] }) ) +
'</td>';
 } ;


}
return __p
};

this["JST"]["templates/card_member_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li class="clearfix text-center col-xs-12">\n\t<div class="clearfix">\n\t\t<a class="js-back-to-card-actions pull-left" href="#"><i class="icon-caret-left"></i></a>\n\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Members') ) +
'</strong></span>\n\t\t<a class="js-close-popup pull-right" href="#"><i class="icon-remove"></i></a>\n\t</div>\n</li>\n<li class="col-xs-12 divider"></li>\n\t\t';
 if (!_.isEmpty(card.board_users.models)) { 
			card.board_users.each(function(board_user) {
				 var added_user = card.users.findWhere({ user_id: board_user.get('user_id') }); 
				 if (_.isEmpty(added_user)) { ;
__p += '\n\t\t\t\t \t<li>\n\t\t\t\t\t\t<a href="#" class="highlight-icon js-add-card-member" data-toggle="tooltip" title="' +
__e(board_user.attributes.full_name ) +
' (' +
__e(board_user.attributes.username ) +
')" data-user-id="' +
__e( board_user.get('user_id') ) +
'" data-user-name="' +
__e(  board_user.get('username') ) +
'" data-user-initial="' +
__e(board_user.get('initials') ) +
'" data-user-profile-picture-path="' +
((__t = (board_user.get('profile_picture_path'))) == null ? '' : __t) +
'" data-user-fullname="' +
__e(board_user.get('full_name') ) +
'">\t\t\t\t\n\t\t\t\t\t\t';
 if(!_.isEmpty(board_user.attributes.profile_picture_path)) { 
							var profile_picture_path = board_user.showImage('User', board_user.attributes.user_id, 'micro_thumb' );
						;
__p += '\n\t\t\t\t\t\t\t<img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(board_user.attributes.username ) +
']" class="img-rounded img-responsive avatar  avatar-sm">\n\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t<i class="avatar avatar-color-194 avatar-sm img-rounded">' +
__e( board_user.attributes.initials ) +
'</i>\t\t\t\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t' +
__e( board_user.get('username') ) +
'</a>\n\t\t\t\t\t</li>\n\t\t\t\t';
 } else { ;
__p += '\n\t\t\t\t\t<li>\n\t\t\t\t\t\t<a href="#" class="highlight-icon js-remove-card-member" data-id="' +
__e(  added_user.id ) +
'"><i class="avatar avatar-color-194 img-rounded" title="' +
__e(  board_user.get('username') ) +
'">' +
__e(board_user.get('initials') ) +
'\n\t\t\t\t\t\t';
 if(!_.isEmpty(board_user.attributes.profile_picture_path)) { 
							var profile_picture_path = board_user.showImage('User', board_user.attributes.id, 'micro_thumb' );
						;
__p += '\n\t\t\t\t\t\t\t<img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(board_user.attributes.username ) +
']" title="' +
__e(board_user.attributes.username ) +
'" class="img-rounded img-responsive avatar  avatar-sm">\n\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t<i class="avatar avatar-color-194 avatar-sm img-rounded">' +
__e( board_user.attributes.initials ) +
'</i>\t\t\t\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t' +
__e(board_user.get('username') ) +
'</i></a> <i class="icon-ok"></i></li>\n\t\t\t\t\t';
 } 
			}); 
		}else{ ;
__p += '\n\t\t\t<li><span class="alert alert-info">' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('members')] }) ) +
'</span></li>\n\t\t';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/card_positions_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {


	var content_list = '<div class="navbar-btn clearfix"><select name="selected_list_id" class="js-change-card-position form-control input-sm cur">';
	var content_position = '<div class="navbar-btn"><select name="card_position" class="js-position form-control col-xs-12 input-sm cur">';
	var filtered_lists = card.list.collection.board.lists.where({
		is_archived:0
	});
	_.each(filtered_lists, function(list) {
		if (card.attributes.list_id == list.id) {
			content_list += '<option value="' + list.id + '" selected="selected">' + _.escape(list.attributes.name) + ' ' + i18next.t('(current)') +'</option>';
			var filtered_cards_count = card.list.collection.board.cards.where({
				list_id: list.id,
				is_archived:0
			}).length;
			var current_position = filtered_cards_count + 1;
			for(var i = 1; i <= filtered_cards_count + 1; i++){
				if (card.attributes.list_id == list.attributes.id && i == current_position) {
					content_position += '<option value="' + i + '" selected="selected">' + i + ' ' + i18next.t('(current)') +' </option>';
				} else {
					content_position += '<option value="' + i + '">' + i+ '</option>';
				}
			}
			if (card.attributes.list_id != list.attributes.id) {
				var next_position = filtered_cards_count + 1;
				content_position += '<option value="' + next_position + '">' + next_position+ '</option>';
			}
		} else {
			content_list += '<option value="' + list.id + '">' + _.escape(list.attributes.name) + '</option>';
		}
	});
	content_list += '</select></div>';
	content_position += '</select></div>';
	var content = content_list + content_position;
;
__p += '\n<div class="clearfix text-center col-xs-12">\t\n\t\t<a href="#" class="js-back-to-card-actions pull-left" ><i class="icon-caret-left  no-pad"></i></a> <span class="col-xs-10"><strong>' +
__e( i18next.t('Position') ) +
'</strong></span><a href="#" class="js-close-sub-popover pull-right"><i class="icon-remove "></i></a>\t\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t' +
((__t = ( content )) == null ? '' : __t) +
'\n</div>';

}
return __p
};

this["JST"]["templates/card_search_result"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p +=
__e( card.attributes.name );

}
return __p
};

this["JST"]["templates/card_search_users_result"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {


	if(user != null){	
;
__p += '\n\t<a data-toggle="tooltip" title="' +
__e( user.attributes.full_name ) +
' (' +
__e( user.attributes.username ) +
')" class="cur ';
if((!_.isUndefined(user.attributes.is_existing_user) || is_added_user)) { if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: 'delete_card_user', board_user_role_id: parseInt(user.attributes.board_user_role_id)})))){;
__p += 'js-remove-card-member';
 } } else{ ;
__p += 'js-add-card-member';
};
__p += '" ';
if(!_.isUndefined(user.attributes.is_existing_user) || is_added_user){ ;
__p += ' data-card-user-id="' +
__e(added_user.id );
};
__p += '" data-user-name="' +
__e( user.attributes.username ) +
'" data-user-initial="' +
__e(user.attributes.initials ) +
'" data-user-fullname="' +
__e(user.attributes.full_name ) +
'" data-user-profile-picture-path="' +
((__t = (user.attributes.profile_picture_path)) == null ? '' : __t) +
'" data-user-id="';
 if (!_.isUndefined(user.attributes.user_id)) { ;
__p +=
__e( user.attributes.user_id );
}else{;
__p +=
__e( user.attributes.id );
};
__p += '">\n\t\t<span>\n\t\t\t';
 if(!_.isEmpty(user.attributes.profile_picture_path)) { 
				var user_id = (!_.isUndefined(user.attributes.user_id))? user.attributes.user_id:user.attributes.id ;
				var profile_picture_path = user.showImage('User', user_id, 'micro_thumb' );
			;
__p += '\n\t\t\t\t<img src="' +
((__t = ( profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(user.attributes.username ) +
']" title="' +
__e(user.attributes.username ) +
'" class="img-rounded img-responsive avatar avatar-sm">\n\t\t\t';
 } else {;
__p += '\n\t\t\t\t<i class="avatar avatar-color-194 avatar-sm img-rounded">' +
__e(user.attributes.initials ) +
'</i>\n\t\t\t';
 } ;
__p += '\n\t\t</span> <span>' +
__e( user.attributes.full_name ) +
' (' +
__e( user.attributes.username ) +
')</span>\n\t';
 if(!_.isUndefined(user.attributes.is_existing_user) || is_added_user){ ;
__p += '<i class="icon-ok"></i>';
};
__p += '</a>\n';
 } else{ ;
__p += '\n\t<div class="col-xs-12 alert alert-info"> ' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('users')] }) ) +
'</div>\n';
 } ;


}
return __p
};

this["JST"]["templates/card_voters_list"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li>\t\t\n\t<div class="clearfix text-center col-xs-12">\n\t\t<span class="col-xs-10"><strong> ' +
__e( i18next.t('Votes') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a>\n\t</div>\n</li>\n<li class="col-xs-12 divider"></li>\n';

	if (!_.isEmpty(card.card_voters.models)){
	card.card_voters.each(function(voter) {            
	;
__p += '\n\t\t<li class="col-xs-12"><a class="js-no-action" data-placement="bottom" data-toggle="tooltip" title="' +
__e( voter.attributes.full_name ) +
' (' +
__e( voter.attributes.username ) +
')" href="#"> \n\t\t<span>\n\t\t\t';
 if(!_.isEmpty(voter.attributes.profile_picture_path)) { 
				var profile_picture_path = card.showImage('User', voter.attributes.user_id, 'micro_thumb' );
			;
__p += '\n\t\t\t\t<img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(voter.attributes.username ) +
']" title="' +
__e(voter.attributes.username ) +
'" class="img-rounded">\n\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t<i class="avatar avatar-color-194 avatar-sm img-rounded">' +
__e( voter.attributes.initials ) +
'</i>\t\t\t\n\t\t\t';
 } ;
__p += '\n\t\t</span>\n\t\t<span>' +
__e( voter.attributes.username ) +
'</span></a></li>\n   ';
 });
   }else{ ;
__p += '\n\t<li class="col-xs-12 alert alert-info">' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('Votes')] }) ) +
'</i>\n   ';
 }  ;
__p += '\n';

}
return __p
};

this["JST"]["templates/change_password"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 col-lg-offset-4 col-md-offset-4 col-sm-offset-3">\n<div class="panel panel-default">\n\t<div class="panel-heading lead"> ' +
__e( i18next.t('Change Password') ) +
'</div>\n\t<div class="panel-body well-lg">\n\t\t<form class="form-horizontal col-xs-12" name="UserChangePasswordForm" id="UserChangePasswordForm">\n\t\t\t\t<div class="form-group input password required">\n\t\t\t\t\t<label class="sr-only control-label" for="inputOldPassword">' +
__e( i18next.t('Old Password') ) +
'</label>\n\t\t\t\t\t<input type="password" class="form-control" placeholder="' +
__e( i18next.t('Old Password') ) +
'" id="inputOldPassword" name="old_password" title="' +
__e( i18next.t('Old Password') ) +
'" required>\n\t\t\t\t</div>\n\t\t\t\t<div class="form-group input password required">\n\t\t\t\t\t<label class="sr-only control-label" for="inputPassword">' +
__e( i18next.t('Enter a new Password') ) +
'</label>\n\t\t\t\t\t<input type="password" class="form-control" placeholder="' +
__e( i18next.t('Enter a new Password') ) +
'" id="inputPassword" name="password" required title="' +
__e( i18next.t('Enter a new Password') ) +
'">\n\t\t\t\t</div>\n\t\t\t\t<div class="form-group input cpassword required">\n\t\t\t\t\t<label class="sr-only control-label" for="inputConfirmPassword">' +
__e( i18next.t('Confirm Password') ) +
'</label>\n\t\t\t\t\t<input type="password" class="form-control" placeholder="' +
__e( i18next.t('Confirm Password') ) +
'" id="inputConfirmPassword" name="confirm_password" required title="' +
__e( i18next.t('Confirm Password') ) +
'">\n\t\t\t\t</div>\n\t\t\t\t<div class="form-group">\n\t\t\t\t\t<label class="sr-only control-label" for="submit2">' +
__e( i18next.t('Change Password') ) +
'</label>\n\t\t\t\t\t<input type="submit" class="btn btn-primary col-xs-12" value="' +
__e( i18next.t('Change Password') ) +
'" id="submitChangePassword" >\n\t\t\t\t</div>\n\t\t</form>\n\t\t</div>\n\t</div>\n</div>';

}
return __p
};

this["JST"]["templates/chat"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<h2> ' +
__e( i18next.t('Coming soon.....') ) +
'</h2> ';

}
return __p
};

this["JST"]["templates/chat_history"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(!_.isEmpty(chat_history) && chat_history != null){ 
	if(chat_history.attributes.created_date != previous_date) {
;
__p += '\n<div class="h3 list-group-item-text navbar-btn well-sm">' +
((__t = (chat_history.attributes.display_date)) == null ? '' : __t) +
'</div>\n<hr class="clearfix"/>\n';
 } ;
__p += '\n<div class="media">\n\t<div class="pull-left">\n\t<strong>' +
__e( chat_history.attributes.created_time ) +
'</strong>\n\t</div>\n\t<div class="pull-left">\n\t<strong>' +
__e( '<' + chat_history.attributes.username + '>' ) +
'</strong>\n\t</div>\n\t<div class="media-body">\n\t\t<span class="js-chat_history-' +
__e( chat_history.attributes.id ) +
'">' +
((__t = ( makeLink(chat_history.attributes.comment, chat_history.attributes.board_id) )) == null ? '' : __t) +
'</span>\n\t</div> \n</div>\n';
 previous_date = chat_history.attributes.created_date; 
}else{ ;
__p += '\n\t<div class="media-body">No Chat History available.</div>\n';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/checklist_actions"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += ' ' +
__e( i18next.t('Delete this Checklist') ) +
'\n';

}
return __p
};

this["JST"]["templates/checklist_add_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="form-group">\n\t<label for="inputListName">' +
__e( i18next.t('Title') ) +
'</label>\n\t<input id="inputListName" type="text" placeholder=" ' +
__e( i18next.t('Title') ) +
'\n" autocomplete="off" class="form-control input-sm" name="name" value="Checklist" title="' +
__e( i18next.t('Whitespace alone not allowed') ) +
' " required pattern=".*\\S+.*">\n</div>\n<div class="form-group">\n\t<label for="copy-items">' +
__e( i18next.t('Copy Items From') ) +
'</label>\n\t<input type="hidden" name="board_id" value="' +
__e( card.attributes.board_id ) +
'" />\n\t<input type="hidden" name="list_id" value="' +
__e( card.attributes.list_id ) +
'" />\n\t<input type="hidden" name="card_id" value="' +
__e( card.id ) +
'" />\n\t<select  name="checklist_id" id="inputchecklist" class="form-control input-sm cur">\n\t\t<option value="0">' +
__e( i18next.t('Please Select') ) +
'</option>\n\t\t';

			var prev_group_id = 0;
			var content = '';
			var checklist_options = [];
			if (card.board_users.board.checklists.models.length > 0) {
				card.board_users.board.checklists.models[0].collection.each(function(checklist_list) {
					var card_name = card.collection.findWhere({
						id: checklist_list.attributes.card_id
					}).get('name');
					var card_id = checklist_list.attributes.card_id
					var i = {};
					i.checklist_id = checklist_list.attributes.id;
					i.checklist_name = checklist_list.attributes.name;
					i.checklist_item_count = !isNaN(checklist_list.attributes.checklist_item_count)?checklist_list.attributes.checklist_item_count:checklist_list.checklist_items.length;
					if (_.isUndefined(checklist_options[card_id])) {
						var c = {};
						c.card_id = card_id;
						c.card_name = card_name;
						c.checklists = [];
						c.checklists.push(i);
						checklist_options[card_id] = c;
					} else {
						checklist_options[card_id].checklists.push(i);
					}
				});
			}
			var content = '';
            if (!_.isEmpty(checklist_options)) {
				checklist_options.forEach(function (checklist_option) {
					content += '<optgroup label="' + _.escape(checklist_option.card_name) + '">';
					checklist_option.checklists.forEach(function (item) {
						content += '<option value="' + item.checklist_id + '">' + _.escape(item.checklist_name) + ' (' + item.checklist_item_count + ' items)</option>';
					});
					content += '</optgroup>';
				});
            }

		;
__p += '\n        ' +
((__t = ( content )) == null ? '' : __t) +
'\n\t</select>\n</div>\n<div class="form-group">\n\t<label for="submit" class="sr-only col-sm-4 control-label">' +
__e( i18next.t('submit') ) +
'</label>\n\t<input type="submit" name="Save" class="btn btn-primary" value="' +
__e( i18next.t('Add') ) +
'">\n</div>';

}
return __p
};

this["JST"]["templates/checklist_delete_confirm_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\n\t<span class="col-xs-10"><strong> ' +
__e( i18next.t('Delete Checklist') ) +
'?\n</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12" id="js-checklist-actions-response-' +
((__t = ( checklist.get('id') )) == null ? '' : __t) +
'">\n\t<p>' +
__e( i18next.t('Deleting a checklist is permanent and there is no way to get it back.') ) +
'</p>\n\t<a class="js-delete-checklist btn  btn-primary" title="' +
__e( i18next.t('Delete Checklist') ) +
'">' +
__e( i18next.t('Delete') ) +
'</a>\n</div>';

}
return __p
};

this["JST"]["templates/checklist_edit_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="form-group">\n\t<label for="inputListName" class="col-sm-4 control-label hide"> ' +
__e( i18next.t('Name') ) +
'\n</label>\n\t<div class="col-sm-10">\n\t\t<textarea name="name" id="checklistEditName" class="form-control" required>' +
__e( checklist.get('name')) +
'</textarea>\n\t</div>\n</div>\n<div class="form-group">\n\t<div class="col-sm-8">\n\t\t<input type="submit" value="' +
__e( i18next.t('Save') ) +
'" class="btn btn-primary"/>\n\t\t<a class="js-hide-checklist-edit-form"><i class="icon-remove btn btn-link"></i></a>\n\t</div>\n</div>';

}
return __p
};

this["JST"]["templates/checklist_item_actions"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\n\t<span class="col-xs-10"><strong> ' +
__e( i18next.t('Options') ) +
'\n</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove "></i></a>\n</div>\n<div class="col-xs-12 divider"></div></li>\n<a href="#" class="js-show-mention-member-form" title="' +
__e( i18next.t('Mention a member') ) +
'">' +
__e( i18next.t('Mention a member') ) +
'</a>\n<a class="js-show-emoji-list-form" title="' +
__e( i18next.t('Add Emoji') ) +
'" href="#">' +
__e( i18next.t('Add Emoji') ) +
'</a>';

}
return __p
};

this["JST"]["templates/checklist_item_add_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="form-group required clearfix">\n\t<label for="inputItemName" class="sr-only"> ' +
__e( i18next.t('Name') ) +
'\n</label>\n\t<div class="clearfix">\n\t\t<textarea name="name" id="ChecklistItem" class="form-control" required></textarea>\n\t</div>\n</div>\n<div class="submit">\n\t<input type="submit" name="Save" class="btn btn-primary" value="' +
__e( i18next.t('Add') ) +
'">\n\t<i class="icon-remove js-hide-checklist-item-add-form btn btn-link cur" title="' +
__e( i18next.t('Cancel') ) +
'"></i>\n\t<div class="navbar-right dropdown">\n\t\t\t<a title="' +
__e( i18next.t('Item Options') ) +
'" class="dropdown-toggle js-show-item-options btn btn-link" data-toggle="dropdown" href="#"><i class="icon-chevron-sign-down"></i></a>\n\t\t\t<ul class="dropdown-menu dropdown-menu-left arrow  js-dropdown-popup dropdown-popup" id="js-item-add-option-response-' +
__e(checklist.id ) +
'">\n\t\t\t</ul>\n\t\t</div>\n</div>';

}
return __p
};

this["JST"]["templates/checklist_item_add_link"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<a class="js-show-checklist-item-add-form js-add-item-view" href="#">' +
__e( i18next.t('Add Item') ) +
'</a>\n<div class="js-checklist-item-add-form-view">\n\n</div>';

}
return __p
};

this["JST"]["templates/checklist_item_delete_confirm_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\n\t<a href="#" class="js-back-to-list-actions pull-left"></a><span class="col-xs-10"><strong>' +
__e( i18next.t('Delete Checklist') ) +
'?</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove "></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<p>' +
__e( i18next.t('Deleting a item is permanent and there is no way to get it back.') ) +
' </p>\n\t<a class="js-delete-item btn  btn-primary" title="' +
__e( i18next.t('Delete Checklist') ) +
'">' +
__e( i18next.t('Delete') ) +
'</a>\n</div>';

}
return __p
};

this["JST"]["templates/checklist_item_edit_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="form-group required">\n\t<label for="inputitemName" class="hide"> ' +
__e( i18next.t('Name') ) +
'\n</label>\n\t<textarea rows="4" id="ChecklistItem" name="name" class="form-control">' +
__e(checklist_item.get('name') ) +
'</textarea>\n</div>\n<div class="form-group">\n\t<div class="col-xs-12 h4 btn-block clearfix">\n\t\t<ul class="clearfix list-unstyled">\n\t\t\t<li class="pull-left">\n\t\t\t\t<div class="submit">\n\t\t\t\t\t<input type="submit" value="' +
__e( i18next.t('Save') ) +
'" class="btn btn-primary"/>\n\t\t\t\t</div>\n\t\t\t</li>\n\t\t\t<li class="pull-left">\n\t\t\t\t<a class="js-hide-item-edit-form"><i class="icon-remove btn btn-link show"></i></a>\n\t\t\t</li>\n\t\t\t<li class="pull-right">\n\t\t\t\t<ul class="list-unstyled">\n\t\t\t\t\t';
 if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(checklist_item.board_users.board.acl_links.where({slug: "delete_checklist_item",board_user_role_id: parseInt(checklist_item.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t<li class="pull-right dropdown">\n\t\t\t\t\t\t<a title="' +
__e( i18next.t('Delete') ) +
'" class="dropdown-toggle js-show-confirm-item-delete btn btn-link btn-sm" data-toggle="dropdown" href="#"><strong>' +
__e( i18next.t('Delete') ) +
'</strong></a>\n\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t\t\t<li class="js-dropdown-popup dropdown-popup" id="js-item-actions-response-' +
__e(checklist_item.id ) +
'"></li>\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t</li>\n\t\t\t\t\t';
  } ;
__p += '\n\t\t\t\t\t';

					if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(checklist_item.board_users.board.acl_links.where({
						slug: "convert_item_to_card",board_user_role_id: parseInt(checklist_item.board_user_role_id)
					})))) { ;
__p += '\n\t\t\t\t\t\t<li class="pull-right">\n\t\t\t\t\t\t\t<a class="btn btn-link btn-sm pull-right js-convert-to-card" href="#" title="' +
__e( i18next.t('Convert to Card') ) +
'"><strong>' +
__e( i18next.t('Convert to Card') ) +
'</strong></a>\n\t\t\t\t\t\t</li>\n\t\t\t\t  ';
  } ;
__p += '\n\t\t\t\t\t<li class="dropdown navbar-right">\n\t\t\t\t\t\t<a title="' +
__e( i18next.t('Item Options') ) +
'" class="dropdown-toggle js-show-item-options btn btn-link btn-sm" data-toggle="dropdown" href="#"><i class="icon-chevron-sign-down"></i></a>\n\t\t\t\t\t\t<ul class="dropdown-menu arrow dropdown-menu-left" id="js-item-option-response-' +
__e(checklist_item.id ) +
'"></ul>\n\t\t\t\t\t</li>\n\t\t\t\t</ul>\n\t\t\t</li>\n\t\t</ul>\n\t</div>\n</div>\n';

}
return __p
};

this["JST"]["templates/checklist_item_emoji_list"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<ul class="list-unstyled">\n<li class="col-xs-12 clearfix text-center">\n<a href="#" class="js-back-to-item-options pull-left"><i class="icon-caret-left"></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t("Add Emoji") ) +
'</strong></span>\n<a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a>\n</li>\n<li class="col-xs-12 divider"></li>\n<li class="col-xs-12 js-comment-emoji-search-response">\n  <div class="clearfix">\n\t<label class="sr-only">' +
__e( i18next.t("Search Member") ) +
'</label>\n\t<input value="' +
__e( search_value ) +
'" type="text" autocomplete="off" placeholder="Search emoji" name="member" class="js-search-emoji form-control input-sm js-no-action" title="Search emoji">\n  </div>\n</li>\n';
 if(!_.isEmpty(emojiLists)){  ;
__p += '\n';
 _.each(emojiLists, function(emojiList){;
__p += '\n\t<li class="col-xs-12 navbar-btn">\n\t  <span>:' +
__e( emojiList ) +
':</span>\n\t  <span class="js-checklist-item-add-emoji">' +
__e( emojiList ) +
'</span>\n\t</li>\n';
});
__p += '\n';
 } else {;
__p += '\n\t<li class="col-xs-12 navbar-btn"><span class="alert alert-info">' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('emoji')] }) ) +
'</span></li>\n';
 } ;
__p += '\n</ul>';

}
return __p
};

this["JST"]["templates/checklist_item_mention_member"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(board_user != null){ ;
__p += '\n<a class="clearfix ';
 if(!_.isUndefined(class_name)){;
__p +=
__e(class_name);
}else{;
__p += 'js-add-item-member';
};
__p += '" data-member-id="' +
__e(board_user.id ) +
'" href="#"> \n\t<span data-placement="bottom" data-toggle="tooltip" title="' +
__e( board_user.attributes.username ) +
'">\n\t';
 if(!_.isEmpty(board_user.attributes.profile_picture_path)) { 
		var profile_picture_path = board_user.showImage('User', board_user.attributes.user_id, 'small_thumb' );
	;
__p += '\n\t\t<img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(board_user.attributes.username ) +
']" title="' +
__e(board_user.attributes.username ) +
'" class="img-rounded img-responsive avatar avatar-sm">\n\t';
 } else {;
__p += '\n\t\t<i class="avatar avatar-color-194 avatar-sm img-rounded">' +
__e(board_user.attributes.initials ) +
'</i>\n\t';
 } ;
__p += '\n\t</span> <span>' +
__e( board_user.attributes.username ) +
'</span>\n\n</a>\n';
 }else{;
__p += '\n<span class="alert alert-info">\n  ' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('users')] }) ) +
'\n</span>\n';
};
__p += '\n';

}
return __p
};

this["JST"]["templates/checklist_item_mention_member_search_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\t\t\t\t\t\t\t\n\t<a href="#" class="js-back-to-item-options pull-left"><i class="icon-caret-left"></i></a><span class="col-xs-10"><strong> ' +
__e( i18next.t('Mention a member') ) +
'\n</strong></span><a href="#" class="js-close-popup pull-right"><i class="icon-remove"></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<ul class="list-unstyled">\n\t\t<li>\n\t\t  <form method="post" class="text-center">\n\t\t\t<div class="form-group">\n\t\t\t  <label class="sr-only">' +
__e( i18next.t('Search Member') ) +
'</label>\n\t\t\t  <input type="text" id="inputItemUserSearch" autocomplete="off" placeholder="' +
__e( i18next.t('Search Members') ) +
'" name="email" required class="js-item-search-member form-control input-sm" title="' +
__e( i18next.t('Search Members') ) +
'">\n\t\t\t</div>\n\t\t  </form>\n\t\t</li>\n\t\t<li class="js-item-member-search-response">\n\t\t\t' +
__e( i18next.t('Search for a person in %s by name or email address.', { postProcess: 'sprintf', sprintf: [SITE_NAME] }) ) +
' \n\t\t\t</li>\n\t</ul>\n</div>';

}
return __p
};

this["JST"]["templates/closed_boards_index"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '  ';
 if(!_.isEmpty(role_links.where({slug: "view_closed_boards"}))){ ;
__p += '\n  <div class="btn-block clearfix">\n    <div class="col-xs-12 js-header-closed-boards">\n\t  <hr>\n    </div>\n  </div>\n  ';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/closed_boards_listing"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(board != null){	
var style = '';
if (board.attributes.background_picture_url) {
	var background_picture_url = board.attributes.background_picture_url.replace("_XXXX.jpg", "_s.jpg");
	style = 'background-image:url(' + background_picture_url + '); background-size:cover;';
} else if (board.attributes.background_pattern_url) {
	var background_pattern_url = board.attributes.background_pattern_url.replace("_XXXX.jpg", "_s.jpg");
	style = 'background-image:url(' + background_pattern_url + '); background-size:cover;';
} else if (board.attributes.background_color){
	style = 'background-color:' + board.attributes.background_color + ';color:#ffffff;';
} else {
	style = '';
}
;
__p += '\n<a href="#/board/' +
__e( board.attributes.id ) +
'" class="col-xs-9">\n<span style="' +
((__t = ( style )) == null ? '' : __t) +
'" class="preview-thumbnail"></span>\n\t<span class="details navbar-btn">\n\t\t<span title="' +
__e( board.attributes.name ) +
'" class="board-list-item-name navbar-btn">' +
__e( board.attributes.name ) +
'</span>\n\t\t<span class="pull-right hide js-stared-conatiner js-stared-conatiner-' +
__e( board.attributes.board_id ) +
'"></span>  \n\t</span> \n</a>\n<div class="pull-right js-reopen-dropdown dropdown">\n\t<a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="btn btn-primary btn-xs"> ' +
__e( i18next.t('Reopen') ) +
'\n</span></a>\n\t<ul class="dropdown-menu reopen-dropdownmenu arrow arrow-right">\n\t\t<li class="js-visibility-popup js-dropdown-popup dropdown-popup">\n\t\t\t<div class="clearfix text-center col-xs-12">\n\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Reopen Board') ) +
'</strong></span>\t\t\t\t\t\n\t\t\t\t<a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\t\t\t\t\t\n\t\t\t</div>\n\t\t\t<div class="col-xs-12 divider"></div>\n\t\t\t<div class="col-xs-12">\n\t\t\t\t<form class="normal" name="BoardReopenForm" >\n\t\t\t\t\t<input name="is_closed" type="hidden" value="false">\n\t\t\t\t\t<div class="h6 btn-block">' +
__e( i18next.t('Are you sure you want to do this action') ) +
'?</div>\n\t\t\t\t\t<div class="submit">\n\t\t\t\t\t\t<span class="btn btn-primary btn-xs js-board-reopen">' +
__e( i18next.t('Reopen') ) +
'</span>\n\t\t\t\t\t</div>\n\t\t\t\t</form>\n\t\t\t</div>\n\t\t</li>\n\t</ul>\n</div>\t\n';
 }else{ ;
__p += '\n <div class="alert alert-info">\n\t' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('boards')] }) ) +
'\n</div>\n';
};


}
return __p
};

this["JST"]["templates/copy_board_visibility"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<span class="pull-left">\n\t<span class="pull-left"> ' +
__e( i18next.t('This board will be') ) +
' </span>\n\t<span class="pull-left">' +
__e( i18next.t('Private') ) +
'</span>.\n</span>\n<a class="pull-left js-change-visibility" href="#">' +
__e( i18next.t('Change') ) +
'</a>\n';
 if (name == 'org') { ;
__p += '\n\t<span class="pull-left"><span class="pull-left">' +
__e( i18next.t('This board will be') ) +
' </span><span class="pull-left">' +
__e( i18next.t('Organization') ) +
'</span>.</span><a class="pull-left js-change-visibility" href="#">' +
__e( i18next.t('Change') ) +
'</a>\n';
 } else if (name == 'public') { ;
__p += '\n\t<span class="pull-left"><span class="pull-left">' +
__e( i18next.t('This board will be') ) +
' </span><span class="pull-left">' +
__e( i18next.t('Public') ) +
'</span>.</span><a class="pull-left js-change-visibility" href="#">' +
__e( i18next.t('Change') ) +
'</a>\n';
 } ;


}
return __p
};

this["JST"]["templates/copy_card"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

        if (card.attachments.length > 0 || card.activities.length > 0 || card.labels.length > 0 || card.checklists.length > 0 || card.users.length > 0) { ;
__p += '\n\t\t<div class="form-group">\n\t\t\t<h4> ' +
__e( i18next.t('Keep...') ) +
'</h4>\n\t\t\t';
 if (card.attachments.length > 0) {;
__p += '\n\t\t\t\t<div class="form-group">\n\t\t\t\t\t<div class="checkbox">\n\t\t\t\t\t<input id="Attachments" class="hide" type="checkbox" name="keep_attachments" value="1" checked="checked">\n\t\t\t\t\t\t<label for="Attachments">\n\t\t\t\t\t\t' +
__e( i18next.t('Attachments') ) +
'(' +
__e( card.attachments.length ) +
')\n\t\t\t\t\t\t</label>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t   ';
 }
		   var comment = card.list.collection.board.activities.where({card_id: card.attributes.id, type: "add_comment"});
			if (comment.length > 0) { ;
__p += '\n\t\t\t   <div class="form-group">\n\t\t\t\t   <div class="checkbox">\n\t\t\t\t\t    <input id="Activities" class="hide" type="checkbox" name="keep_activities" value="1" checked="checked">\n\t\t\t\t\t\t<label for="Activities">\n\t\t\t\t\t\t\t' +
__e( i18next.t('Comments') ) +
' (' +
__e( comment.length ) +
')\n\t\t\t\t\t\t</label>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t   ';
  }
			if (card.labels.length > 0) { ;
__p += '\n\t\t\t   <div class="form-group">\n\t\t\t\t   <div class="checkbox">\n\t\t\t\t\t    <input id="Labels" class="hide" type="checkbox" name="keep_labels" value="1" checked="checked">\n\t\t\t\t\t\t<label for="Labels">\n\t\t\t\t\t\t\t' +
__e( i18next.t('Labels') ) +
' (' +
__e( card.labels.length ) +
')\n\t\t\t\t\t\t</label>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t';
}
		     if (card.checklists.length > 0) { ;
__p += '\n\t\t\t\t<div class="form-group">\n\t\t\t\t\t<div class="checkbox">\n\t\t\t\t\t\t<input id="Checklists" class="hide" type="checkbox" name="keep_checklists" value="1" checked="checked">\n\t\t\t\t\t\t<label for="Checklists">\n\t\t\t\t\t\t\t' +
__e( i18next.t('Checklists') ) +
' (' +
__e( card.checklists.length ) +
')\n\t\t\t\t\t\t</label>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t   ';
 }
			if (card.users.length > 0) { ;
__p += '\n\t\t\t\t<div class="form-group">\n\t\t\t\t\t<div class="checkbox">\n\t\t\t\t\t\t<input id="users" class="hide" type="checkbox" name="keep_users" value="1" checked="checked">\n\t\t\t\t\t\t<label for="users">\n\t\t\t\t\t\t\t' +
__e( i18next.t('Members') ) +
' (' +
__e( card.users.length ) +
')\n\t\t\t\t\t\t</label>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t   ';
 } ;
__p += '\n\t\t</div>\n';
	} 
        var content_board = '<div class="form-group clearfix"><select name="board_id" class="js-change-list col-xs-12 form-control panel-body cur">';
        var content_list = '<div class="form-group clearfix"><select name="list_id" class="js-change-position col-xs-12 form-control panel-body cur">';
        var content_position = '<div class="form-group clearfix"><select name="position" class="js-position col-xs-12 form-control panel-body cur">';
		var current_position = card.collection.indexOf(card) + 1;
        boards.each(function(board) {
	if (card.attributes.board_id == board.id) {
		content_board += '<option value="' + board.id + '" selected="selected">' + _.escape(board.attributes.name) + ' '+ i18next.t('(current)')+'</option>';
		board.lists.add(board.attributes.lists);
		var filtered_lists = board.lists.where({
			is_archived: 0
		});
		_.each(filtered_lists, function(list) {
			if (card.attributes.list_id == list.id) {
				content_list += '<option value="' + list.id + '" selected="selected">' + _.escape(list.attributes.name) + ' '+ i18next.t('(current)')+'</option>';
				for(var i = 1; i <= list.attributes.card_count; i++){
					if (card.attributes.list_id == list.attributes.id && i == current_position) {
						content_position += '<option value="' + i + '" selected="selected">' + i + ' '+i18next.t('(current)')+'</option>';
					} else {
						content_position += '<option value="' + i + '">' + i+ '</option>';
					}
				}
				
				var next_position = parseInt(list.attributes.card_count ) + 1;
				if( isNaN(list.attributes.card_count))
					next_position = 1;				
				content_position += '<option value="' + next_position + '">' + next_position + '</option>';
				
			} else {
				content_list += '<option value="' + list.id + '">' + _.escape(list.attributes.name) + '</option>';
			}

		});
	} else {
		content_board += '<option value="' + board.id + '">' + _.escape(board.attributes.name) + '</option>';
	}

});
        content_board += '</select></div>';
        content_list += '</select></div>';
        content_position += '</select></div>';
		var content = content_board + content_list + content_position;
;
__p += '\t\t\n' +
((__t = ( content )) == null ? '' : __t);

}
return __p
};

this["JST"]["templates/copy_from_existing_card"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li><h4 class="text-center">' +
__e( i18next.t('Copy Card') ) +
'</h4></li>\n<li class="divider"></li>\n<li>\n\t<form role="form" method="post" class="js-copy-existing-card-form col-xs-12">\n\t\t<div class="col-xs-12">\n\t\t\t<div class="form-group">\n\t\t\t\t<label for="card-title">' +
__e( i18next.t('Title') ) +
'</label>\n\t\t\t\t<textarea id="card-title" class="form-control" rows="3" name="name">' +
__e(card.attributes.name) +
'</textarea>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="js-show-move-card-form-response col-xs-12">\n\t\t';

			var content = '';
			var content_board = '<div class="form-group"><select name="board_id" class="js-change-list form-control cur">';
			var content_list = '<div class="form-group"><select name="list_id" class="js-change-position form-control cur">';
			var content_position = '<div class="form-group"><select name="position" class="js-position form-control cur">';
			var is_first = true;
			boards.each(function(board) {
				 if (card.attributes.board_id == board.id) {
				 	 is_first = true;
					 content_board += '<option value="' + board.id + '" selected="selected">' + _.escape(board.attributes.name) + ' '+i18next.t('(current)')+'</option>';
				 } else {
					 content_board += '<option value="' + board.id + '">' + _.escape(board.attributes.name) + '</option>';
				 }
				 if(is_first){
				 	 is_first = false;
					 content_list = '<div class="form-group"><select name="list_id" class="js-change-position form-control cur">';
					 board.lists.add(board.attributes.lists);
					 var is_first_list = true;
					 board.lists.each(function(list) {
						is_first = false;
						 if (card.attributes.list_id == list.id) {
						 	 is_first_list = true;
							 content_list += '<option value="' + list.id + '" selected="selected">' + _.escape(list.attributes.name) + ' '+i18next.t('(current)')+'</option>';
							 board.cards.add(board.attributes.cards);
						 } else {
							 content_list += '<option value="' + list.id + '">' + _.escape(list.attributes.name) + '</option>';
						 }
						  if(is_first_list){
						  	content_position = '<div class="form-group"><select name="position" class="js-position form-control cur">';
							is_first_list = false;
							for(var i = 1; i <= list.attributes.card_count; i++){
								content_position += '<option value="' + i + '">' + i+ '</option>';
							}
						}
				
					 });
				 
				 }
			});
			content_board += '</select></div>';
			content_list += '</select></div>';
			content_position += '</select></div>';
			content = content_board + content_list + content_position;
		;
__p += '\n\t\t' +
((__t = ( content)) == null ? '' : __t) +
'\n\t\t</div>\n\t\t<div class="form-group col-xs-12 clearfix">\n\t\t\t<label class="sr-only">' +
__e( i18next.t('Create card') ) +
'</label>\n\t\t\t<input name="copied_card_id" type="hidden" value="' +
__e(card.attributes.id) +
'"/>\n\t\t\t<input type="submit" class="btn btn-primary col-xs-12 js-copy-existing-card" value="' +
__e( i18next.t('Create card') ) +
'">\n\t\t</div>\n\t</form>\n</li>\n\n\t\t\t\t';

}
return __p
};

this["JST"]["templates/copy_list"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\t\n\t<a href="#" class="js-back-to-list-actions pull-left" data-list-id="' +
__e( list.id ) +
'"><i class="icon-caret-left"></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t('Copy List') ) +
'</strong></span><a href="#" class="js-close-popup pull-right"><i class="icon-remove"></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n\t\t\t<div class="col-xs-12">\n\t<form class="js-add-list" name="ListCloneForm" id="ListCloneForm">\n\t\t<div class="form-group required">\n\t\t\t<label for="inputListName">' +
__e( i18next.t('Name') ) +
'</label>\n\t\t\t<input maxlength="255" id="inputListName" type="text" name="name" autocomplete="off" placeHolder="' +
__e( i18next.t('Add a list') ) +
'" class="form-control input-sm" value="' +
__e( list.attributes.name ) +
'" required title="' +
__e( i18next.t('Add a list') ) +
'"/>\n\t\t\t<input type="hidden" value="' +
__e( list.id ) +
'" name="clone_list_id"/>\n\t\t\t<input type="hidden" value="' +
__e( list.attributes.position ) +
'" name="position"/>\n\t\t</div>\n\t\t<div class="submit">\n\t\t\t<input type="submit" id="submitListAdd" class="btn  btn-primary" value="' +
__e( i18next.t('Create List') ) +
'"/>\n\t\t</div>\n\t</form>\n</div>';

}
return __p
};

this["JST"]["templates/edit_activity_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<ul class="media-list">\n<li class="media comment-block">\n<div class="form-group required">\n\t<textarea rows="4" class="js-inputComment form-control js-comment" name="comment" required>' +
__e( activity.attributes.comment ) +
'</textarea>\n\t<input type="hidden" value="' +
__e( activity.attributes.id) +
'" name="id"/>\n</div>\n</li>\n<li class="js-new-comment clearfix btn-block navbar-btn">\n<div class="col-xs-11 radio pull-right btn-block">\n\t<ul class="list-unstyled clearfix col-xs-12">\n\t\t<li class="pull-left radio-inline">\n\t\t\t<div class="clearfix dropdown js-show-emoji-list-response"> <a class="js-show-emoji-list show dropdown-toggle btn-link btn-xs btn-block" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Add Emoji') ) +
'" href="#"> <span class="text-muted show" >' +
__e( i18next.t('Add Emoji') ) +
'</span> </a>\n\t\t\t</div>\n\t\t</li>\n\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(activity.board.acl_links.where({slug: "view_card_search", board_user_role_id: parseInt(activity.board_user_role_id)})))) { ;
__p += '\n\t\t\t<li class="pull-left radio radio-inline">\n\t\t\t  <div class="clearfix dropdown"> <a class="show dropdown-toggle btn-link btn-xs btn-block" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Add Card') ) +
'" href="#"> <span class="text-muted show" >' +
__e( i18next.t('Add Card') ) +
'</span> </a>\n\t\t\t\t<ul class="dropdown-menu arrow col-xs-3 list-group">\n\t\t\t\t  <li class="col-xs-12 clearfix text-center">\n\t\t\t\t\t<div><span class="col-xs-10"><strong>' +
__e( i18next.t('Add Card') ) +
'</strong></span>\n\t\t\t\t\t<a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div>\n\t\t\t\t  </li>\n\t\t\t\t  <li class="col-xs-12 divider"></li>\n\t\t\t\t  <li class="col-xs-12 js_activity_card_search_response">\n\t\t\t\t\t  <div class="clearfix">\n\t\t\t\t\t\t<label class="sr-only">' +
__e( i18next.t('Search Card') ) +
'</label>                            \n\t\t\t\t\t\t  <input type="text" placeholder="' +
__e( i18next.t('Search Card') ) +
'" name="card" class="js-search-card form-control input-sm  js-no-action" title="' +
__e( i18next.t('Search Card') ) +
'">\n\t\t\t\t\t  </div>\n\t\t\t\t  </li>\n\t\t\t\t</ul>\n\t\t\t  </div>\n\t\t\t</li>\n\t\t';
 } ;
__p += '\n\t\t<li class="dropdown pull-left radio-inline radio">\n\t\t  <div class="clearfix dropdown"> <a class="show dropdown-toggle btn-link btn-xs btn-block js-show-members" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Mention a member') ) +
'" href="#"> <span class="text-muted show" >' +
__e( i18next.t('Mention a member') ) +
'</span> </a>\n\t\t\t<ul class="dropdown-menu arrow col-xs-3">\n\t\t\t  <li class="col-xs-12 clearfix text-center"><div><span class="col-xs-10"><strong>' +
__e( i18next.t('Mention a member') ) +
'</strong></span> <a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div></li>\n\t\t\t  <li class="col-xs-12 divider"></li>\n\t\t\t  <li class="col-xs-12 js-comment-member-search-response">\n\t\t\t\t  <div class="clearfix">\n\t\t\t\t\t<label class="sr-only">' +
__e( i18next.t('Search Member') ) +
'</label>\n\t\t\t\t\t<input type="text" autocomplete="off" placeholder="' +
__e( i18next.t('Search Members') ) +
'" name="member" class="js-search-member form-control input-sm js-no-action" title="' +
__e( i18next.t('Search Members') ) +
'">\n\t\t\t\t  </div>\n\t\t\t  </li>\n\t\t\t</ul>\n\t\t   </div>\n\t\t</li>\n\t</ul>\n<div class="submit panel-body">\n<input type="submit" id="submitListAdd" class="btn  btn-primary" value="Save"/>\n<i class="icon-remove js-hide-edit-comment-form btn btn-link cur" title="Cancel" data-activity-id="' +
__e( activity.attributes.id) +
'"></i>\n</div>\n</li>\n';

}
return __p
};

this["JST"]["templates/edit_board_member_permission_to_admin"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<ul class="list-unstyled list-inline clearfix">\n\t<li>\n\t\t<a class="js-show-board-member-permission-form" data-board_user_id="' +
((__t = ( board_user_id )) == null ? '' : __t) +
'" href="#">\n\t\t\t<span class="js-change-permission-content-' +
((__t = ( board_user_id )) == null ? '' : __t) +
'">' +
__e( i18next.t("Owner") ) +
'</span>\n\t\t</a>\n\t</li>\n\t<li>\n\t\t<a href="#" class="show js-board-user-activity">' +
__e( i18next.t("Activity") ) +
'</a>\n\t</li>\n\t<li>\n\t\t<div disabled="disabled"><span>' +
__e( i18next.t("Remove from board") ) +
'</span></div>\n\t</li>\n</ul>';

}
return __p
};

this["JST"]["templates/edit_board_member_permission_to_normal"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<ul class="list-unstyled list-inline clearfix">\n\t<li>\n\t\t<a class="js-show-board-member-permission-form" data-board_user_id="' +
__e( board_user_id ) +
'" href="#">\n\t\t\t<span class="js-change-permission-content-' +
__e( board_user_id ) +
'">' +
__e( i18next.t("Member") ) +
'</span>\n\t\t</a>\n\t</li>\n\t<li>\n\t\t<a href="#" class=" show js-board-user-activity">' +
__e( i18next.t("Activity") ) +
'</a></li>\n\t\t<li>\n\t\t\t<a class="js-show-confirm-delete-board-member" data-board_user_id="' +
__e( board_user_id ) +
'" href="#">\n\t\t\t\t<span>' +
__e( i18next.t("Remove from board") ) +
'</span>\n\t\t\t</a>\n\t\t</li>\n</ul>';

}
return __p
};

this["JST"]["templates/email_templates"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<!-- Main block start -->\n\n<section class="clearfix row">\n  <div class="col-xs-12">\n\t<div class="clearfix">\n\t\t<ul class="nav nav-tabs no-bor h3">\n\t\t';
 
			var i = 0;
			if (list.models.length > 0 ) { 
				_.each(list.models, function(email_tempalte) {				
					var settings = email_tempalte.get('template');
		;
__p += '\n\t\t\t\t<li ';
 if (!_.isUndefined(id) && id == email_tempalte.get('id')) { ;
__p += 'class="active" ';
} else if (_.isUndefined(id) && email_tempalte.get('id') == 1) { ;
__p += 'class="active" ';
};
__p += ' ><a href="#/email_templates/' +
__e(email_tempalte.get('id')) +
'">' +
__e( i18next.t(email_tempalte.get('display_name')) ) +
'</a></li>\n\t\t';
 
					i++;
				});
			} 
		;
__p += '\n\t\t</ul>\n\t</div>\n\t\n\t<div class="row">\n\t\t<div class="tab-content col-sm-10">\n\t\t';
 if (list.models.length > 0 ) { 
				var j = 0;
				_.each(list.models, function(email_tempalte) {	
					var template = email_tempalte.get('template');
		;
__p += '\t\t\n\t\t\t\t<div class="modal-body tab-pane clearfix ';
 if (!_.isUndefined(id) && id == email_tempalte.get('id')) { ;
__p += ' active ';
} else if (_.isUndefined(id) && email_tempalte.get('id') == 1) { ;
__p += ' active ';
};
__p += '" id="settingTab' +
__e( email_tempalte.get('id') ) +
'">\n\t\t\t\t\t';
 if(!_.isEmpty(template)){ ;
__p += '\n\t\t\t\t\t<p class="alert alert-info ">' +
__e( i18next.t(template.description) ) +
'</p>\n\t\t\t\t\t<form class="form-horizontal js-email-templates-form" role="form" id="js-email-templates-form">\n\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t <label for="inputFromEmail" class="col-md-2 col-sm-3 control-label">' +
__e( i18next.t("From") ) +
'</label>\n\t\t\t\t\t\t <div class="col-md-4 col-sm-9">\n\t\t\t\t\t\t\t<input type="text" id="inputFromEmail" name="from_email" class="form-control" value="' +
__e( template.from_email ) +
'" />\n\t\t\t\t\t\t </div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t <label for="inputReplyToEmail" class="col-md-2 col-sm-3 control-label">' +
__e( i18next.t("Reply To") ) +
'</label>\n\t\t\t\t\t\t <div class="col-md-4 col-sm-9">\n\t\t\t\t\t\t\t<input type="text" id="inputReplyToEmail" name="reply_to_email" class="form-control" value="' +
__e( template.reply_to_email ) +
'" />\n\t\t\t\t\t\t </div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t <label for="inputSubject" class="col-md-2 col-sm-3 control-label">' +
__e( i18next.t("Subject") ) +
'</label>\n\t\t\t\t\t\t <div class="col-md-4 col-sm-9">\n\t\t\t\t\t\t\t<input type="text" id="inputSubject" name="subject" class="form-control" value="' +
__e( template.subject ) +
'" />\n\t\t\t\t\t\t\t<span class="info">' +
__e( template.email_variables ) +
'</span>\n\t\t\t\t\t\t </div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t <label class="col-md-2 col-sm-3 control-label" for="EmailTemplateEmailTextContent">' +
__e( i18next.t("Email Content") ) +
'</label>\n\t\t\t\t\t\t<div class="col-md-10 col-sm-9">\n\t\t\t\t\t\t\t<textarea id="EmailTemplateEmailTextContent" class="form-control" name="email_text_content"\trows="20">' +
__e( template.email_text_content ) +
'</textarea>\n\t\t\t\t\t\t\t<span class="info">' +
__e( template.email_variables ) +
'</span>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t<label for="submit2" class="sr-only col-md-2 col-sm-3 control-label">' +
__e( i18next.t("Submit") ) +
'</label>\n\t\t\t\t\t\t<div class="col-md-4 col-sm-9">\n\t\t\t\t\t\t<input type="submit" value="' +
__e( i18next.t('Update') ) +
'" id="submit2" class="btn btn-primary">\n\t\t\t\t\t\t</div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t</form>\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t</div>\n\t\t';
 
					j++;
				});
			} 
		;
__p += '\t\t\t\t\n\t\t</div>\n\t</div>\n  </div>\n</section>\n<!-- Main block end -->';

}
return __p
};

this["JST"]["templates/email_to_board_setting"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<ul class="list-unstyled">\n\t<li>\n\t\t<div class="clearfix text-center col-xs-12">\n\t\t\t<a href="#" class="js-back-to-sidebar pull-left btn btn-xs btn-link"><i class="icon-caret-left"></i></a> \n\t\t\t<span class="col-xs-10 navbar-btn"><strong>' +
__e( i18next.t("Add Cards via Email") ) +
'</strong></span>\n\t\t</div>\n\t\t<div class="col-xs-12 divider"></div>\n\t\t<div class="col-xs-12">\n\t\t\t<div class="form-group">\n\t\t\t  <label for="boardEmail">' +
__e( i18next.t("Your email address for this board") ) +
'</label>\n\t\t\t  <input type="text" readonly="readonly" value="' +
__e( board_email ) +
'" class="form-control js-board-email" name="boardEmail" id="boardEmail">\n\t\t\t</div>\n\t\t\t<div class="col-xs-12 divider"></div>\n\t\t\t<div class="form-group">\n\t\t\t  <p>' +
__e( i18next.t("Your emailed cards appear in...") ) +
'</p>\n\t\t\t  <label>' +
__e( i18next.t("List") ) +
'</label>\n\t\t\t  <select class="js-select-list form-control input-sm cur list-group" placeholder="' +
__e( i18next.t('List') ) +
'">\n\t\t\t  ';
 _.each(board.lists.models, function(list) { 
				  if(parseInt(list.attributes.is_archived) === 0){
			  ;
__p += '\n\t\t\t\t<option ';
 if(board.attributes.default_email_list_id === list.attributes.id){ ;
__p += 'selected';
 } ;
__p += ' value="' +
__e( list.attributes.id ) +
'">' +
__e( list.attributes.name ) +
'</option>\n\t\t\t  ';
 } 
			  });
			  ;
__p += '\n\t\t\t  </select>\n\t\t\t  <label>' +
__e( i18next.t("Position") ) +
'</label>\n\t\t\t  <select class="js-select-position form-control input-sm cur">\n\t\t\t\t<option ';
 if(parseInt(board.attributes.is_default_email_position_as_bottom) === 0){ ;
__p += 'selected';
 } ;
__p += ' value="false">' +
__e( i18next.t('Top') ) +
'</option>\n\t\t\t\t<option ';
 if(parseInt(board.attributes.is_default_email_position_as_bottom) === 1){ ;
__p += 'selected';
 } ;
__p += ' value="true">' +
__e( i18next.t('Bottom') ) +
'</option>\n\t\t\t  </select>\n\t\t\t</div>\n\t\t</div>\n\t</li>\n</ul>';

}
return __p
};

this["JST"]["templates/emoji_list"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li class="col-xs-12 clearfix text-center">\n<div><span class="col-xs-10"><strong>' +
__e( i18next.t("Add Emoji") ) +
'</strong></span>\n<a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div>\n</li>\n<li class="col-xs-12 divider"></li>\n<li class="col-xs-12 js-comment-emoji-search-response">\n  <div class="clearfix">\n\t<label class="sr-only">' +
__e( i18next.t("Search Member") ) +
'</label>\n\t<input value="' +
__e( search_value ) +
'" type="text" autocomplete="off" placeholder="Search emoji" name="member" class="js-search-emoji form-control input-sm js-no-action" title="Search emoji">\n  </div>\n</li>\n';
 if(!_.isEmpty(emojiLists)){  ;
__p += '\n';
 _.each(emojiLists, function(emojiList){;
__p += '\n\t<li class="col-xs-12 navbar-btn">\n\t  <span>:' +
__e( emojiList ) +
':</span>\n\t  <span class="js-comment-add-emoji">' +
__e( emojiList ) +
'</span>\n\t</li>\n';
});
__p += '\n';
 } else {;
__p += '\n\t<li class="col-xs-12 navbar-btn"><span class="alert alert-info">' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('emoji')] }) ) +
'</span></li>\n';
 } ;


}
return __p
};

this["JST"]["templates/error_404"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p +=
__e( i18next.t("404 Page not found") ) +
'.';

}
return __p
};

this["JST"]["templates/flickr"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(photo != null){ ;
__p += ' \n\t';

		var path =  '//farm' + photo.farm + '.static.flickr.com/' + photo.server + '/' + photo.id + '_' + photo.secret + '_s.jpg';
	;
__p += '\n\t<div class="clearfix">\n\t\t<a class="pull-left navbar-btn js-flickr-changebackground" href="#" target="_blank" data-farm="' +
((__t = ( photo.farm)) == null ? '' : __t) +
'" data-server="' +
((__t = ( photo.server)) == null ? '' : __t) +
'" data-id="' +
((__t = ( photo.id)) == null ? '' : __t) +
'" data-secret="' +
((__t = ( photo.secret)) == null ? '' : __t) +
'" data-title="' +
((__t = ( photo.title)) == null ? '' : __t) +
'">\n\t\t\t<img class="img-rounded" title="' +
((__t = ( photo.title)) == null ? '' : __t) +
'" alt="[Image: ' +
((__t = ( photo.title)) == null ? '' : __t) +
']" src="' +
((__t = ( path)) == null ? '' : __t) +
'" width="48" height="48">\n\t\t</a>\n\t</div>\t\n';
 } ;
__p += ' ';

}
return __p
};

this["JST"]["templates/footer"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {


if (_.isEmpty(role_links.where({
	slug: "add_board"
}))) {
	var delete_github_obj = apps;
	if (delete_github_obj.hasOwnProperty('r_import_github')) {
		delete delete_github_obj['r_import_github'];
	}
}
;
__p += '\n<section class="action-block action-content">\n<div class="row navbar navbar-default list-group-item-text">\n<ul class="nav nav-pills navbar-left"> \n  <li class="footer-logo visible-xs active"> \n  \t<a href="javascript:void(0);" title="' +
__e( SITE_NAME ) +
'" class="js-start"><sup class="badge notification-count js-notification-count"></sup><img src="img/logo-icon.png" alt="[Images: ' +
__e( SITE_NAME ) +
']" title="' +
__e( SITE_NAME ) +
'" id="js-footer-brand-img" /></a>\n\t<!-- Todo: quick fix. load image before offline. call after when goes offline\n\t<img src="img/logo-icon-offline.png" alt="[Images: ' +
__e( SITE_NAME ) +
']" style="display:none;" />--->\n  </li>\n  <li class="hidden-xs about-btn">\n\t<a href="#/about" title="RestyaBoard">\n\t\t<img title="Restya" alt="[Image: ' +
__e( SITE_NAME ) +
']" src="img/logo-icon.png">\n\t\t<span class="hidden-lg hidden-md hidden-sm navbar-btn">&nbsp;' +
__e( i18next.t("About") ) +
'</span>\n\t\t<!-- Todo: quick fix. load image before offline. call after when goes offline--->\n\t\t<img src="img/logo-icon-offline.png" alt="[Images: ' +
__e( SITE_NAME ) +
']" style="display:none;" />\n\t</a>\n   </li>   \n  ';
 if(!_.isUndefined(authuser.user)){;
__p += '\n\t<li class="hidden-xs music-btn pa"> \n\t\t';
 if(board_id !== undefined && board_id !== null && board_id !== "" && !_.isEmpty(this.music_content) && this.music_content !== ''){ ;
__p += '\n\t\t\t';
 if(parseInt(authuser.user.is_productivity_beats) === 1) { ;
__p += '\n\t\t\t\t<a href="#" data-toggle="tooltip" data-container="body" data-placement="top" data-original-title="' +
__e( i18next.t('Productivity Beats - %s', { postProcess: 'sprintf', sprintf: [this.music_name]}) ) +
'" title="' +
__e( i18next.t('Productivity Beats - %s', { postProcess: 'sprintf', sprintf: [this.music_name]}) ) +
'" class="animation btn btn-default js-product-beat-action" data-type=\'on\'>\n\t\t\t\t<span class="show"><i class="icon-volume-up lead tada-animation show"></i></span>\n\t\t\t\t</a>\n\t\t\t';
 } else { ;
__p += '\n\t\t\t\t<a href="#" data-toggle="tooltip" data-container="body" data-placement="top" data-original-title="' +
__e( i18next.t('Productivity Beats - %s', { postProcess: 'sprintf', sprintf: [this.music_name]}) ) +
'" title="' +
__e( i18next.t('Productivity Beats - %s', { postProcess: 'sprintf', sprintf: [this.music_name]}) ) +
'" class="animation btn btn-default js-product-beat-action" data-type=\'off\'>\n\t\t\t\t<span class="show"><i class="icon-volume-off lead text-muted show"></i></span>\n\t\t\t\t</a>\n\t\t\t';
 } ;
__p += '\n\t\t';
 } ;
__p += '\n\t</li> \n\t';
 } else { ;
__p += '\n\t<li class="hidden-xs music-btn pa">\n\t\t';
 if(board_id !== undefined && board_id !== null && board_id !== "" && !_.isEmpty(this.music_content) && this.music_content !== ''){ ;
__p += '\n\t\t\t';
 if(window.sessionStorage.getItem('music_play') === "1") { ;
__p += '\n\t\t\t\t<a href="#" data-toggle="tooltip" data-container="body" data-placement="top" data-original-title="' +
__e( i18next.t('Productivity Beats - %s', { postProcess: 'sprintf', sprintf: [this.music_name]}) ) +
'" title="' +
__e( i18next.t('Productivity Beats - %s', { postProcess: 'sprintf', sprintf: [this.music_name]}) ) +
'" class="animation btn btn-default js-product-beat-action" data-type=\'on\'>\n\t\t\t\t<span class="show"><i class="icon-volume-up lead show"></i></span>\n\t\t\t\t</a>\n\t\t\t';
 } else { ;
__p += '\n\t\t\t\t<a href="#" data-toggle="tooltip" data-container="body" data-placement="top" data-original-title="' +
__e( i18next.t('Productivity Beats - %s', { postProcess: 'sprintf', sprintf: [this.music_name]}) ) +
'" title="' +
__e( i18next.t('Productivity Beats - %s', { postProcess: 'sprintf', sprintf: [this.music_name]}) ) +
'" class="animation btn btn-default js-product-beat-action" data-type=\'off\'>\n\t\t\t\t<span class="show"><i class="icon-volume-off lead show text-muted"></i></span>\n\t\t\t\t</a>\n\t\t\t';
 } ;
__p += '\n\t\t';
 } ;
__p += '\n\t</li> \n\t\n\t';
 };
__p += '\n ';
 if(!_.isUndefined(authuser.user)){;
__p += '\n  <li class="dropdown hidden-xs board-btn"> \n\t  <a title="' +
__e( i18next.t('Dashboard') ) +
'" href="#" data-toggle="dropdown" class="btn btn-default js-show-boards-list"><span>' +
__e( i18next.t("Boards") ) +
' </span><span><i class="icon-collapse"></i></span> </a>\n\t  <ul role="menu" class="dropdown-menu js-dropdown-popup col-xs-12 js-show-add-boards-list">\n\t  \t <li class="js-show-boards-list-response"></li>\n\t\t ';
 if(!_.isEmpty(role_links.where({slug: "view_board_search"}))){ ;
__p += '\n\t\t\t <li class="clearfix js-qsearch-container js-boards-list-container">\n\t\t\t\t<div class="clearfix h6 col-xs-12">\n\t\t\t\t\t<input type="text" placeholder="' +
__e( i18next.t('Find boards by name...') ) +
'" class="js-search-boards form-control" id="inputBoardSearch" title="Find boards by name...">\n\t\t\t\t</div>\n\t\t\t </li>\n\t\t\t <li class="divider"></li>\n\t\t ';
 } ;
__p += '\n\t\t ';


			if (!_.isEmpty(role_links.where({
				slug: "view_closed_boards"
			}))) {
		;
__p += '\n\t\t\t<li class="clearfix js-closed-board-list dropdown dropdown-submenu dropdown js-boards-list-container-search">            \n\t\t\t\t<a href="#" class="js-board-dropdown dropdown-toggle js-open-popover js-closed-boards" data-toggle="dropdown" title="' +
__e( i18next.t('Closed Boards') ) +
'">' +
__e( i18next.t("Closed Boards") ) +
'</a>\n\t\t\t\t<ul class="sidebar-boards-list js-closedboard-list  list-unstyled list-group dropdown-menu"></ul>\n\t\t\t\t</li>\n\t\t';

			}
			if (!_.isEmpty(role_links.where({
				slug: "view_stared_boards"
			}))) {
		;
__p += '\n\t\t\t<li class="clearfix js-board-dropdown js-stared-board-lists dropdown-submenu dropdown js-boards-list-container-search">            \n\t\t\t\t\t<a href="#" class="dropdown-toggle js-open-popover js-starred-boards" data-toggle="dropdown" title="' +
__e( i18next.t('Starred Boards') ) +
'">' +
__e( i18next.t("Starred Boards") ) +
'</a>\t\t\t\t\n\t\t\t\t\t<ul class="sidebar-boards-list js-board-starred-list list-unstyled list-group dropdown-menu"></ul>\t\t\t\n\t\t\t\t</li>\n\t\t';

			}

			if (!_.isEmpty(role_links.where({
				slug: "view_my_boards"
			}))) {
		;
__p += '\n\t\t\t\t<li class="clearfix js-my-board-lists dropdown-submenu dropdown js-boards-list-container-search">\t\t\t\n\t\t\t\t\t<a href="#" class="js-board-dropdown dropdown-toggle js-open-popover js-my-boards-listing" data-toggle="dropdown" title="' +
__e( i18next.t('My Boards') ) +
'">' +
__e( i18next.t("My Boards") ) +
'</a>\n\t\t\t\t\t<ul class="sidebar-boards-list js-myboard-list list-unstyled list-group dropdown-menu"></ul>\t\t\t\n\t\t\t\t</li>\n\t\t';

			} 		
		;
__p += '\n\t\t\t<li class="clearfix js-boards-list-container-search">            \n\t\t\t<a href="#/" title="' +
__e( i18next.t('Boards') ) +
'">' +
__e( i18next.t("Boards") ) +
'</a>\n\t\t\t</li>\n\t\t';


			if (!_.isEmpty(role_links.where({
				slug: "add_board"
			})) || !_.isEmpty(role_links.where({
				slug: "add_organization"
			}))) {
		;
__p += '\t\t\n\t\t\t<li class="divider js-boards-list-container-search"></li>\n\t\t\t<li class="js-boards-list-container-search dropdown clearfix">\n\t\t\t\t<a title="' +
__e( i18next.t('Add Board or Organization') ) +
'" class="dropdown-toggle js-show-organizations-board-from btn btn-link" data-toggle="dropdown" href="#"><span class="pull-left"><i class="icon-plus"></i></span> ' +
__e( i18next.t("Add Board or Organization") ) +
'</a><ul role="menu" class="dropdown-menu dropdown-menu-right js-show-organizations-board-from-response js-dropdown-popup navbar-btn"></ul>\n\t\t\t\t</li>\n\t\t';
   
			 }
		;
__p += '\n\t  </ul>\n\t</li>\n  ';
 if(typeof(model.user) !== "undefined" && !_.isEmpty(model.user) && (!_.isEmpty(role_links.where({slug: "view_organization_listing"})))){ ;
__p += '\n  <li class="hidden-xs org-btn"><a title="' +
__e( i18next.t('Organizations') ) +
'" href="#/organizations" class="btn btn-default"><span>' +
__e( i18next.t("Organizations") ) +
'</span></a></li>\n   ';
 } ;
__p += '\t\n  ';
 if(apps !== ""){ ;
__p += '\n  <li class="dropdown hidden-xs board-btn js-show-add-apps-list add-apps-list"> \n\t  <a title="' +
__e( i18next.t('Apps') ) +
'" href="#" data-toggle="dropdown" class="btn btn-default js-show-apps-list"><span>' +
__e( i18next.t("Apps") ) +
' </span><span><i class="icon-collapse"></i></span> </a>\n\t  <ul role="menu" class="dropdown-menu js-dropdown-popup col-xs-12">\n\t\t\t';
 _.each(apps, function(key,value) { ;
__p += '\n\t\t\t\t<li id="' +
__e( value ) +
'" class="org-btn"><a title="' +
__e( i18next.t(key.name) ) +
'" href="#" data-toggle="modal" data-target="#' +
__e( value ) +
'_modal" class="highlight-icon clearfix"><span style="background-image:url(' +
__e( key.icon ) +
'); background-size:cover;" class="preview-thumbnail"></span><span class="details btn-block navbar-btn">' +
__e( i18next.t(key.name) ) +
'</span></a></li>\n\t\t\t';
 }); ;
__p += '\n\t\t\t<li class="divider js-apps-list-container-search"></li>\n\t\t\t<li class="dropdown clearfix">\n\t\t\t\t<a title="' +
__e( i18next.t('Add Apps') ) +
'" class="dropdown-toggle  btn-link" target="_blank" href="http://restya.com/board/apps/?utm_source=Restyaboard - ' +
__e( SITE_NAME ) +
'&utm_medium=web&utm_campaign=add_apps_footer"><span class="pull-left"><i class="icon-plus"></i></span> &nbsp; ' +
__e( i18next.t("Add Apps") ) +
'</a>\n\t\t\t</li>\n\t  </ul>\n\t</li>\n  ';
 } ;
__p += '\n  ';
 } ;
__p += '\n</ul>\n';
 if(!_.isUndefined(authuser.user)){;
__p += '\n<div class="col-xs-push-0 col-sm-push-1 col-md-push-1 col-lg-push-1 col-lg-4 col-md-3 col-sm-1 col-xs-12 hidden-xs search-xs list-group-item-heading clearfix">\n\t<form role="form" class="search-container clearfix">\n\t<div class="text-center clearfix hide search-loader" id="js-loader-img"><img src="img/ajax-loader.gif" alt="[Images:Loader]" title="Loading..." /></div>\n\t  <div class="form-group">\n\t\t<input id="search-box" type="search" class="search-box pull-right form-control js-search search-box">\n\t\t<i class="icon-circle-blank search-loader hide" id="res"></i>\n\t\t<i class="icon-circle-blank search-loader text-primary hide" id="nres"></i>\n\t\t<label for="search-box" class="pull-right"><i class="icon-search btn btn-primary search-icon"></i></label>\n\t\t<ul class="dropdown-menu">\n\t\t\t<li class="js-show-search-result js-dropdown-popup dropdown-popup">\n\t\t\t</li>\n\t\t</ul>\n\t  </div>\n\t  <button type="submit" class="search-submit sr-only">' +
__e( i18next.t("Submit") ) +
'</button>\n\t</form>\n</div>\n ';
 } ;
__p += '\n<div class="navbar-right clearfix">\n\t<ul class="nav nav-pills navbar-right">\n\t';
 if(!_.isUndefined(authuser.user)){;
__p += '\n\t';
 if((navigator.userAgent.toLowerCase().indexOf('android') > -1) && (navigator.userAgent.toLowerCase().indexOf('chrome') > -1)){ ;
__p += '\n\t\t  <li class="hidden-xs"><a href="#" tittle="' +
__e( i18next.t('Install this webapp to your phone') ) +
'" data-toggle="modal" data-target="#add_home_modal" class="btn btn-default pull-right"><i class="icon-plus"></i></a></li>\n\t';
 } ;
__p += '\n\t';
 if (!_.isUndefined(authuser.user) &&  !_.isEmpty(model.user) && model.user.role_id == 1) { ;
__p += '\n\t\t<li class="phone-block"><a class="btn btn-primary pull-right js-show-qr-code hidden-xs" id="phone" title="' +
__e( i18next.t('View in iOS App') ) +
'" href=""><i class="icon-mobile-phone lead"></i></a></li>\n\t  \t<li class="hidden-xs"><a title="' +
__e( i18next.t('Admin CP') ) +
'" class="btn btn-default pull-right admin-cp" href="#/activities"><span class="icon-user lead text-primary"></span><span class="hidden-xs text-primary">' +
__e( i18next.t("Admin") ) +
'</span></a></li>\n\t  ';
 } ;
__p += '\n\t  <li class="dropdown">\n\t   <a href="#" data-toggle="dropdown" class="dropdown-toggle btn btn-default pull-right" title="' +
__e(model.user.full_name) +
' (' +
__e(model.user.username) +
')">\n\t   \t\t<span class="js-user-img">\n\t\t\t';
 if(!_.isEmpty(model.user.profile_picture_path)){ 
				var profile_picture_path = model.showImage('User', model.user.id, 'micro_thumb', true);
			;
__p += '\n\t\t\t\t<img class="img-rounded" width="16" height="16" src="' +
((__t = ( profile_picture_path)) == null ? '' : __t) +
'" alt="[Images: ' +
__e( model.user.username) +
']" title="' +
__e( model.user.username) +
'" />\n\t\t\t';
 }else{ ;
__p += '\n\t\t\t\t<i class="avatar avatar-color-194 avatar-sm">' +
__e( model.user.initials) +
'</i>\n\t\t\t';
 } ;
__p += ' \n\t\t\t</span>&nbsp; <b class="caret"></b>\n\t   </a>\n\t\t<ul class="dropdown-menu text-left js-change-avatar-form-response">\n\t\t\t<li> <a title="' +
__e( i18next.t('Logout') ) +
'" href="#/users/logout">' +
__e( i18next.t("Logout") ) +
'</a> </li>\t\t\t\n\t\t\t<li class="divider"></li>\n\t\t\t<li><a href="#" class="js-show-shortcuts-modal" data-toggle="modal" data-target="#ModalShortcutView">' +
__e( i18next.t('Shortcuts') ) +
'</a></li>\n\t\t\t';
 if(model.is_show_enable_notification === true) { ;
__p += '\n\t\t\t\t<li><a title="' +
__e( i18next.t('Enable Desktop Notification') ) +
'" href="#" class="js-enable-desktop-notification">' +
__e( i18next.t("Enable Desktop Notification") ) +
'</a></li>\n\t\t\t';
 } ;
__p += '\t\n\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "user_changepassword"})) && parseInt(authuser.user.is_ldap) === 0){ ;
__p += '\n\t\t\t\t<li><a title="' +
__e( i18next.t('Change Password') ) +
'" href="#/users/' +
__e(model.user.id) +
'/changepassword">' +
__e( i18next.t("Change Password") ) +
'</a></li>\n\t\t\t';
 } ;
__p += '\n\t\t    ';
 if(!_.isEmpty(role_links.where({slug: "view_user"}))){ ;
__p += '\n\t\t\t\t<li><a title="' +
__e( i18next.t('Profile') ) +
'" href="#/user/' +
__e(model.user.id) +
'">' +
__e( i18next.t("Profile") ) +
'</a></li>\n\t\t\t';
 } ;
__p += '\n\t\t\t<li class="dropdown-submenu dropdown language-dropdown">\n\t\t\t\t<a href="#" data-toggle="dropdown" class="dropdown-toggle js-open-popover" title="' +
__e( i18next.t('Change Language') ) +
'"><span><i class="icon-caret-left"></i></span>' +
__e( i18next.t('Change Language') ) +
'</a>\n\t\t\t\t<ul class="dropdown-menu text-left js-change-language-form-response">\n\t\t\t\t   ';
 _.each(JSON.parse(languages), function(v, k) { ;
__p += '\n\t\t\t\t\t\t<li> <a class="cur ';
 if(k !== authuser.user.language) { ;
__p += 'js-change-language';
};
__p += '" data-lang="' +
__e( k ) +
'">' +
__e( v );
 if((!_.isEmpty(authuser.user.language) && k === authuser.user.language) || (_.isEmpty(authuser.user.language) && k === DEFAULT_LANGUAGE)){ ;
__p += '<i class="icon-ok"></i>';
 } ;
__p += '</a> </li>\t\t\t\n\t\t\t\t   ';
 }); ;
__p += '\n\t\t\t\t   <li class="divider"></li>\n\t\t\t\t   <li> <a href="http://transifex.com/restya/restyaboard/?utm_source=Restyaboard&utm_medium=web&utm_campaign=translation_footer" target="_blank" title="' +
__e( i18next.t('Contribute to Translation') ) +
'"><span class="pull-left"><i class="icon-plus"></i></span>&nbsp;  ' +
__e( i18next.t('Contribute to Translation') ) +
'</a>\n\t\t\t\t   </li>\n\t\t\t\t</ul>\n\t\t\t</li>\n\t\t</ul>\n\t  </li>\n\t  <li class="hidden-xs"><a data-toggle="tooltip" data-placement="top" title="' +
__e( i18next.t('Chat') ) +
'" ';
 if(typeof(model.user) !== "undefined" && !_.isEmpty(model.user)){ ;
__p += 'href="#" ';
 }else{ ;
__p += ' href="#/users/login"';
 };
__p += ' id="add" class="btn btn-default pull-right  ';
 if(typeof(model.user) !== "undefined" && !_.isEmpty(model.user)){ ;
__p += 'js-show-chat';
 };
__p += '" data-original-title="' +
__e( i18next.t('Chat') ) +
'"><i class="icon-comment lead"></i></a></li> \n\t  <li class="hidden-xs"><a data-container="body" data-toggle="tooltip" data-placement="top" title="' +
__e( i18next.t('Instant add card') ) +
'" ';
 if(typeof(model.user) !== "undefined" && !_.isEmpty(model.user)){ ;
__p += 'href="#" ';
 }else{ ;
__p += ' href="#/users/login"';
 };
__p += ' id="add" class="btn btn-default pull-right  ';
 if(typeof(model.user) !== "undefined" && !_.isEmpty(model.user)){ ;
__p += 'js-show-instant-card-from';
 };
__p += '" data-original-title="Add New"><i class="icon-plus-sign lead"></i></a></li>\n\t  <li class="dropdown notifications pull-right hidden-xs"><a data-toggle="dropdown" href="#" class="btn btn-default pull-right js-show-notification" title="Notifications"><sup class="badge notification-count hide js-notification-count"></sup><i class="icon-bell lead"></i></a>\n\t\t<div id="all_activities" class="tabbable tabs-below dropdown-menu pull-right js-dropdown-popup" role="menu">\n\t\t  <div class="tab-content bg-info clearfix">\n\t\t    <div class="col-xs-12 user-filter navbar-btn">\n\t\t\t\t<span class="pull-left"><strong>' +
__e( i18next.t('Activity') ) +
'</strong></span>\n\t\t\t\t<ul class="nav nav-pills pull-right mob-no-mar">\n\t\t\t\t\t<li id="modal-activities"><a href="#" title="' +
__e( i18next.t('Filter by activities') ) +
'" class="text-muted"><i class="icon-time small"></i></a></li>\n\t\t\t\t\t<li id="modal-comments"><a href="#" title="' +
__e( i18next.t('Filter by comments') ) +
'" class="text-muted"><i class=" icon-comment-alt small"></i></a></li>\n\t\t\t\t</ul>    \n\t\t\t</div> \n\t\t\t<div class="tab-pane js-all-activity-list notification-list vertical-scrollbar col-xs-12 border-top" id="all_">\n\t\t\t\t<ul id="js-all-activities" class="list-unstyled clearfix navbar-btn"></ul> \n\t\t\t</div>\n\t\t\t';
 if(!_.isEmpty(board_id)) { ;
__p += '           \n\t\t\t\t<div class="tab-pane js-boards-activity-list active notification-list vertical-scrollbar col-xs-12 border-top" id="board_">\n\t\t\t\t\t<ul id="js-board-activities"  class="list-unstyled clearfix navbar-btn"></ul>\n\t\t\t\t</div>        \n\t\t\t';
 } ;
__p += ' \n\t\t\t\t';
 if(!_.isEmpty(board_id) && board_id !== 0 && board_id !== '0') { ;
__p += '\n\t\t\t\t\t<div class="col-xs-12 border-top text-center js-load-link" id="js-load-link1">\n\t\t\t\t\t\t<a href="#" title="View all activity" id="js-notification-load-more" class="js-board-load-more btn btn-link">' +
__e( i18next.t("Load more activities") ) +
'</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="col-xs-12 border-top text-center js-load-link hide" id="js-load-link2">\n\t\t\t\t\t\t<a href="#" title="' +
__e( i18next.t('View all activity') ) +
'" id="js-notification-load-more-all" class="js-board-load-more-all btn btn-link">' +
__e( i18next.t("Load more activities") ) +
'</a>\n\t\t\t\t\t</div>\n\t\t\t\t';
} else { ;
__p += '  \n\t\t\t\t<div class="col-xs-12 border-top text-center js-load-link" id="js-load-link">\n\t\t\t\t\t<a href="#" title="' +
__e( i18next.t('View all activity') ) +
'" id="js-notification-load-more-all" class="js-all-load-more-all btn btn-link">' +
__e( i18next.t("Load more activities") ) +
'</a>\n\t\t\t\t</div>  \n\t\t\t\t';
 } ;
__p += '\n\t\t\t </div>\n\t\t\t<ul class="nav nav-tabs ';
 if(_.isEmpty(board_id)){ ;
__p += 'hide';
 } ;
__p += '"> \n\t\t\t\t<li><a href="#all_" data-toggle="tab" class="js-all-activities">' +
__e( i18next.t('All') ) +
'</a></li>\n\t\t\t\t\n\t\t\t\t';
 if(!_.isEmpty(board_id) && board_id !== 0 && board_id !== '0' && (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(board.acl_links.where({slug: "view_board_activities", board_user_role_id: parseInt(board.board_user_role_id)}))))) { ;
__p += '\n\t\t\t\t\t<li class="active"><a href="#board_" data-toggle="tab" class="js-board-activities">' +
__e( i18next.t("In this board") ) +
'</a></li>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t</ul>\n\t\t</div>\n\t  </li>\n\t  ';
 } else { ;
__p += '\n\t\t';
 if(board_id !== undefined && board_id !== null && board_id !== ""){ ;
__p += '\n\t  \t\t<li class="';
 if(Backbone.history.fragment.indexOf('users/register') != -1){;
__p += 'active';
};
__p += '"><a href="#/users/register" title="' +
__e( i18next.t('Register') ) +
'"><strong>' +
__e( i18next.t("Register") ) +
'</strong></a></li>\n\t\t\t<li class="';
 if(Backbone.history.fragment.indexOf('users/login') != -1){;
__p += 'active';
};
__p += '"><a href="#/users/login"\ttitle="' +
__e( i18next.t('Login') ) +
'"><strong>' +
__e( i18next.t("Login") ) +
'</strong></a></li>\n\t\t';
 } ;
__p += '\n\t  ';
 } ;
__p += '\n\t </ul>\n</div>\n<div class="hidden-blocks hide js-hidden-blocks"></div>\t\n</div>\n</section>\n<section class="search-block-main" id="search-page-result-block"></section>\n';

}
return __p
};

this["JST"]["templates/header"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(_.isEmpty(current_param) || ((typeof(user) == "undefined" || (typeof(user) != "undefined" && user.role_id != 1)) || (current_param !== 'activities' && current_param !== 'users' && current_param !== 'roles' && current_param !== 'apps' && current_param !== 'settings' && current_param !== 'email_templates' && current_param !== 'boards' && current_param !== 'admin_boards_list' && current_param !== 'oauth_clients' && current_param !== 'board_user_roles' && current_param !== 'organization_user_roles'))){ ;
__p += '\n<div id="js-navbar-default" class="navbar navbar-default" role="navigation">\n  <div class="container-fluid">\n  <div class="row">\n\t<div class="navbar-left">\n\t  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse"> <span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> </button>\n\t  <div class="clearfix"><h2 class="navbar-left navbar-btn list-group-item-text"><span class="navbar-left"><a href="#/" title="' +
__e( SITE_NAME ) +
'"><img src="img/logo.png" alt="[Image: ' +
__e( SITE_NAME ) +
']" title="' +
__e( SITE_NAME ) +
'" class="img-responsive center-block"/></a></span></h1>\n\t  </div>\n\t</div>\n\t<nav class="navbar-collapse collapse">\n\t<div class="navbar-right navbar-btn h4">\n\t  \n\t  ';
  if(typeof(user) == "undefined") { ;
__p += '\n\t  \t<ul class="nav nav-pills navbar-left">\n\t  \t';

			if(!_.isEmpty(role_links.where({slug: "users_register"}))) {
				if(!_.isEmpty(LDAP_LOGIN_ENABLED) && LDAP_LOGIN_ENABLED === "false") {
		;
__p += '\n\t\t<li class="';
 if(Backbone.history.fragment.indexOf('users/register') != -1){;
__p += 'active';
};
__p += '"><a href="#/users/register" title="' +
__e( i18next.t('Register') ) +
'"><strong>' +
__e( i18next.t("Register") ) +
'</strong></a></li>\n\t\t ';
 	
				}
		   }
			if(!_.isEmpty(role_links.where({slug: "users_login"}))){
		 ;
__p += '\n\t\t<li class="';
 if(Backbone.history.fragment.indexOf('users/login') != -1){;
__p += 'active';
};
__p += '"><a href="#/users/login" title="' +
__e( i18next.t('Login') ) +
'"><strong>' +
__e( i18next.t("Login") ) +
'</strong></a></li>\n\t\t ';

		 	}
		 ;
__p += '\n\t\t </ul>\n\t ';
 }else{ ;
__p += ' \n\t \t<ul class="nav nav-pills navbar-left">\n\t\t\t<li class="';
  var fragment = Backbone.history.fragment; var fragments = fragment.split('/'); if(fragment.indexOf('boards')  != -1 && fragments.length == 1){;
__p += 'active';
};
__p += '"><a href="#/boards" title="' +
__e( i18next.t('My Boards') ) +
'" class="text-muted list-group-item-text navbar-btn h4"><i class="icon-user"></i></a></li>\n            <li class="';
 if(Backbone.history.fragment.indexOf('boards/starred') != -1){;
__p += 'active';
};
__p += '"><a href="#/boards/starred" title="' +
__e( i18next.t('Starred Boards') ) +
'" class="text-muted list-group-item-text navbar-btn h4"><i class="icon-star"></i></a></li>\n\t\t\t<li class="';
 if(Backbone.history.fragment.indexOf('boards/closed') != -1){;
__p += 'active';
};
__p += '"><a href="#/boards/closed" title="' +
__e( i18next.t('Closed Boards') ) +
'" class="text-muted list-group-item-text navbar-btn h4"><i class="icon-th-large"></i></a></li>\n        </ul>\n\t ';
 };
__p += '\n\t  \n\t</div>\n\t</nav>\n   </div>\n  </div>\n</div>\n';
 } else if(typeof(user) != "undefined" && !_.isEmpty(current_param) && (current_param === 'activities' || current_param === 'users' || current_param === 'roles' || current_param === 'apps' || current_param === 'settings' || current_param === 'email_templates' || current_param === 'admin_boards_list'|| current_param === 'oauth_clients' || current_param === 'board_user_roles' || current_param === 'organization_user_roles')){ ;
__p += '\n';
 
	if(!_.isEmpty(current_param) && (current_param === 'activities')) {
		current_title = i18next.t('Activities');
	} else if(!_.isEmpty(current_param) && (current_param === 'users')){ 
		current_title = i18next.t('Users');
	} else if(!_.isEmpty(current_param) && (current_param === 'roles' || current_param === 'board_user_roles' || current_param === 'organization_user_roles')){ 
		current_title = i18next.t('Roles');
	} else if(!_.isEmpty(current_param) && (current_param === 'apps')){ 
		current_title = i18next.t('Apps');
	} else if(!_.isEmpty(current_param) && (current_param === 'settings')){ 
		current_title = i18next.t('Settings');
	} else if(!_.isEmpty(current_param) && (current_param === 'email_templates')){ 
		current_title = i18next.t('Email Templates');
	} else if(!_.isEmpty(current_param) && (current_param === 'admin_boards_list')){ 
		current_title = i18next.t('Boards');
	} else if(!_.isEmpty(current_param) && (current_param === 'oauth_clients')){ 
		current_title = i18next.t('Developer applications');
	} 
;
__p += '\n\n<div class="container-fluid bg-primary">\n<div class="navbar-header">\n\t<button data-toggle="collapse" data-target=".navbar-collapse" class="navbar-toggle" type="button"> \n\t\t<span class="sr-only">' +
__e( i18next.t("Toggle navigation") ) +
'</span> \n\t\t<span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> \n\t</button>\n  <div class="clearfix navbar-left"> \n\t<h1 class="navbar-left navbar-btn mob-no-mar clearfix"><div class="navbar-left"><a href="#/" title="' +
__e( SITE_NAME ) +
'"><img src="img/logo.png" alt="[Image: ' +
__e( SITE_NAME ) +
']" title="' +
__e( SITE_NAME ) +
'" class="img-responsive center-block"></a></div></h1>\n\t<ul class="list-inline navbar-left h2 navbar-btn navbar-form whitec text-center hidden-xs">\n            <li class="navbar-btn "><span class="h5">/</span></li>\n            <li><span class="icon-user h3"></span><span class="h4"> ' +
__e( i18next.t("Admin CP") ) +
'</span></li>\n            <li class="navbar-btn "><span class="h5">/</span></li>\n            <li id="js-navbar-header"><span class="h4">' +
__e( current_title ) +
'</span></li>\n     </ul>\n\t ';
 if(!_.isEmpty(current_param) && (current_param === 'users')){ ;
__p += '\n\t <div class="pull-left well-sm"> <div class="js-dropdown dropdown  docmodal-submenu row">\n              <a data-toggle="dropdown" id="dropdownMenu1" class="dropdown-toggle label" href="#"> <i class="icon-cog h3"></i></a>\n              <ul role="menu" class="dropdown-menu arrow">\n                 <li class="text-center text-muted"><strong>' +
__e( i18next.t("Sort") ) +
'</strong></li>\n                 <li class="divider"></li>\n                 <li><a title="' +
__e( i18next.t('Username') ) +
'" href="#" class="js-sort-by" data-field="username">' +
__e( i18next.t("Username") ) +
'</a></li>\n\t\t\t\t <li class="dropdown-submenu inner-dropdown dropdown"> <a href="#" title="' +
__e( i18next.t('Roles') ) +
'" data-toggle="dropdown" class="dropdown-toggle js-open-popover">' +
__e( i18next.t("Roles") ) +
'</a>\n                  <ul class="dropdown-menu">\n\t\t\t\t    <li class="inner-dropdown dropdown">\n\t\t\t\t\t\t<a title="' +
__e( i18next.t('Admin (%s)', { postProcess: 'sprintf', sprintf: [this.admin_board_users]}) ) +
'" href="#" class="js-sort-by" data-field="role_id">' +
__e( i18next.t("Admin (%s)", { postProcess: 'sprintf', sprintf: [this.admin_board_users]}) ) +
'</a>\n\t\t\t\t\t</li>\n                    <li class="inner-dropdown dropdown">\n\t\t\t\t\t\t<a title="' +
__e( i18next.t('User (%s)', { postProcess: 'sprintf', sprintf: [this.normal_board_users]}) ) +
'" href="#" class="js-sort-by" data-field="role_id">' +
__e( i18next.t("User (%s)", { postProcess: 'sprintf', sprintf: [this.normal_board_users]}) ) +
'</a>\n\t\t\t\t\t</li>\n                  </ul>\n                </li>\n                <li class="dropdown-submenu inner-dropdown dropdown"> <a href="#" title="' +
__e( i18next.t('Login') ) +
'" data-toggle="dropdown" class="dropdown-toggle js-open-popover">' +
__e( i18next.t("Login") ) +
'</a>\n                  <ul class="dropdown-menu">\n                    <li class="inner-dropdown dropdown">\n\t\t\t\t\t\t<a title="' +
__e( i18next.t('Login Time') ) +
'" href="#" class="js-sort-by" data-field="last_login_date">' +
__e( i18next.t("Time") ) +
'</a>\n\t\t\t\t\t</li>\n                    <li class="inner-dropdown dropdown">\n\t\t\t\t\t\t<a title="' +
__e( i18next.t('Login IP') ) +
'" href="#" class="js-sort-by" data-field="last_login_ip">' +
__e( i18next.t("IP") ) +
'</a>\n\t\t\t\t\t</li>\n                  </ul>\n                </li>\n                <li class="dropdown-submenu inner-dropdown dropdown"> <a href="#" title="' +
__e( i18next.t('Registered') ) +
'" data-toggle="dropdown" class="dropdown-toggle js-open-popover">' +
__e( i18next.t("Registered") ) +
'</a>\n                  <ul class="dropdown-menu">\n                    <li class="inner-dropdown dropdown">\n\t\t\t\t\t\t<a title="' +
__e( i18next.t('Time') ) +
'" href="#" class="js-sort-by" data-field="created">' +
__e( i18next.t("Time") ) +
'</a>\n\t\t\t\t\t</li>\n                    <li>\n\t\t\t\t\t\t<a title="' +
__e( i18next.t('IP') ) +
'" href="#" class="js-sort-by" data-field="registered_ip">' +
__e( i18next.t("IP") ) +
'</a>\n\t\t\t\t\t</li>\n                  </ul>\n                </li>\n                <li><a title="' +
__e( i18next.t('Organizations Count') ) +
'" href="#" class="js-sort-by" data-field="joined_organization_count">' +
__e( i18next.t("Organizations Count") ) +
'</a>\n\t\t\t\t</li>\n                <li><a title="' +
__e( i18next.t('Board Count') ) +
'" href="#" class="js-sort-by" data-field="joined_board_count">' +
__e( i18next.t("Board Count") ) +
'</a>\n\t\t\t\t</li>\n              </ul>\n            </div></div>\n\t\t\t\t';
 if (!_.isEmpty(LDAP_LOGIN_ENABLED) && LDAP_LOGIN_ENABLED === "false") { ;
__p += '\n\t\t\t\t\t<div class="pull-left well-sm"><a class="label" href="#/users/admin_user_add" title="' +
__e( i18next.t('Add User') ) +
'"><i class="icon-plus-sign h3"></i><span class="h4">' +
__e( i18next.t("Add User") ) +
'</span></a></div>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t';
 } ;
__p += '\n\t\t\t';
 if(!_.isEmpty(current_param) && (current_param === 'oauth_clients')){ ;
__p += '\n\t\t\t\t<div class="pull-left well-sm"><a class="label" href="#/oauth_clients/add" title="' +
__e( i18next.t('New application') ) +
'"><i class="icon-plus-sign h3"></i><span class="h4">' +
__e( i18next.t("New application") ) +
'</span></a></div>\n\t\t\t';
 } ;
__p += '\n\t</div>\n\t</div>\n\t<nav class="navbar-collapse collapse"> \n\t<div class="navbar-right clearfix">\n\t\t<ul class="nav nav-pills navbar-left navbar-btn">\n\t\t\t<li class="js-admin-activity-menu navbar-btn"><a title="' +
__e( i18next.t('Activities') ) +
'" href="#/activities">' +
__e( i18next.t("Activities") ) +
'</a></li>\n\t\t\t<li class="js-admin-user-menu navbar-btn"><a title="' +
__e( i18next.t('Users') ) +
'" href="#/users">' +
__e( i18next.t("Users") ) +
'</a></li>\n\t\t\t<li class="js-admin-board-menu navbar-btn"><a title="' +
__e( i18next.t('Boards') ) +
'" href="#/boards/list">' +
__e( i18next.t("Boards") ) +
'</a></li>\n\t\t\t<li class="js-admin-role-menu navbar-btn"><a title="' +
__e( i18next.t('Roles') ) +
'" href="#/roles">' +
__e( i18next.t("Roles") ) +
'</a></li>\n\t\t\t<li class="js-admin-app-menu navbar-btn"><a title="' +
__e( i18next.t('Apps') ) +
'" href="#/apps">' +
__e( i18next.t("Apps") ) +
'</a></li>\n\t\t\t<li class="js-admin-client-menu navbar-btn"><a title="' +
__e( i18next.t('Developer applications') ) +
'" href="#/oauth_clients">' +
__e( i18next.t("Developer applications") ) +
'</a></li>\n\t\t\t<li class="js-admin-setting-menu navbar-btn"><a title="' +
__e( i18next.t('Settings') ) +
'" href="#/settings">' +
__e( i18next.t("Settings") ) +
'</a></li>\n\t\t\t<li class="js-admin-email-menu navbar-btn"><a title="' +
__e( i18next.t('Email Templates') ) +
'" href="#/email_templates">' +
__e( i18next.t("Email Templates") ) +
'</a></li>\n\t\t</ul>\n\t</div>\n\t</nav>\n</div>\n';
 } else { ;
__p += '\n<div role="navigation" class="navbar navbar-default" id="js-navbar-default">\n  <div class="container-fluid">\n  <div class="row">\n\t<div class="navbar-left">\n\t  \n\t  <div class="clearfix"><h2 class="navbar-left navbar-btn list-group-item-text"><span class="navbar-left"><a title="Restyaboard1" href="#/"><img src="img/logo.png" alt="[Image: ' +
__e( SITE_NAME ) +
']" title="' +
__e( SITE_NAME ) +
'" class="img-responsive center-block"/></a></span></h2>\n\t  </div>\n\t</div>\n\t\n   </div>\n  </div>\n</div>\n';
 } ;


}
return __p
};

this["JST"]["templates/instant_card_add"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if (boards.models.length == 0 || _.isEmpty(boards.models[0])) { ;
__p += '\n\t';
 if (boards.models.length == 0) { ;
__p += '\n \t\t\tPlease add board.\n\t';
 }else if ( _.isEmpty(boards.models[0])){ ;
__p += '\n\t\t\tPlease add list.\n\t';
 };
__p += '\n';
 }else { ;
__p += '\n<form class="form-horizontal js-instantCardAddForm js-outside-backbone" role="form" name="CardAddForm" >\n\t<div class="clearfix" >\n\t\t<div class="form-group">\n\t\t\t<label for="title" class="sr-only">Card Title</label>\n\t\t\t<div class="col-xs-12">\n\t\t\t\t<input type="text" class="form-control" placeholder="' +
__e( i18next.t('Card Title') ) +
'" name="name" id="inputCardName" title="' +
__e( i18next.t('Card Title') ) +
'" required />\n\t\t\t\t<input type="hidden" value="" class="js-instant-card-user-ids" name="user_ids">\n\t\t\t</div>\n\t\t</div>\n\t\t';
 if (boards.models.length > 0) { ;
__p += '\n\t\t\t<div class="form-group">\n\t\t\t\t<div class="col-xs-6">\n\t\t\t\t\t<select name="board_id"  id="board_id" class="js-chosen-select col-xs-12 js-instant-card-board" placeholder="' +
__e( i18next.t('Select Board') ) +
'">\n\t\t\t\t\t<option></option>\n\t\t\t\t\t';
  var first_board = null;
						_.each(boards.models, function(board) {
							if (!_.isEmpty(board.attributes.lists) && board.attributes.lists.length > 0) {
								if (first_board === null) {
									first_board = board;
								};
__p += '\n\t\t\t\t\t\t\t\t<option value="' +
__e(board.id) +
'">' +
__e( board.attributes.name) +
'</option>\n\t\t\t\t\t\t   ';
}
						});
					;
__p += '\n\t\t\t\t\t</select>\n\t\t\t\t</div>\n\t\t\t\t<div class="col-xs-6">\n\t\t\t\t\t<select name="list_id" id="list_id" class="js-chosen-select col-xs-12 js-instant-card-add-list" placeholder="' +
__e( i18next.t('Select List') ) +
'">\n\t\t\t\t\t<option></option>\n\t\t\t\t\t';

						if (first_board !== null) {
							_.each(first_board.attributes.lists, function(list) {
				    ;
__p += '\n\t\t\t\t\t\t\t\t<option value="' +
__e( list.id) +
'">' +
__e( list.name ) +
'</option>\n\t\t\t\t\t';
		}); ;
__p += '\n\t\t\t\t\t</select>\n\t\t\t\t\t';
		var position = _.max(first_board.attributes.lists, function(list) {
								return list.position;
							});
							if (isNaN(position.position)) {
								position.position = first_board.attributes.board_lists.length;
							}
					;
__p += '\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\n\t\t';
 } ;
__p += '\n\t\t <div class="form-group">\n\t\t \t<label class="sr-only">' +
__e( i18next.t("Description") ) +
'</label>\n\t\t\t<div class="col-xs-12">\n\t\t\t\t<textarea class="form-control" rows="3" placeholder="' +
__e( i18next.t('Description') ) +
'" name="description" id="inputCardDescription" tile="' +
__e( i18next.t("Description") ) +
'" required></textarea>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="clearfix form-group">\n\t\t\t<div class="col-xs-12">\n\t\t\t\t<ul class="list-inline pull-left card-view-mn">\n\t\t\t\t\t<li class="dropdown dropup">\n\t\t\t\t\t\t<a title="' +
__e( i18next.t('Users') ) +
'" class="btn btn-link dropdown-toggle js-add-member-dropdown" data-toggle="dropdown" href="#"><i class="icon-user js-instant-user text-muted"></i></a>\n\t\t\t\t\t\t<ul class="dropdown-menu js-dropdown-popup arrow arrow-bottom">\n\t\t\t\t\t\t\t<li class="js-add-member-dropdown-load js-dropdown-popup dropdown-popup js-instant-card-member-search-response">\n\t\t\t\t\t\t\t\t<div class="col-xs-12 text-center clearfix"><span class="col-xs-10"><strong>' +
__e( i18next.t("Members") ) +
'</strong></span><a href="#" class="js-close-popover pull-right"><i class="icon-remove "></i></a></div>\n\t\t\t\t\t\t\t\t <div class="col-xs-12 divider"></div>\n\t\t\t\t\t\t\t\t <div class="col-xs-12">\n\t\t\t\t\t\t\t\t\t <div class="form-group">\n\t\t\t\t\t\t\t\t\t   <label class="sr-only">' +
__e( i18next.t("Search Member") ) +
'</label>\n\t\t\t\t\t\t\t\t\t   <div class="col-xs-12"><input type="text" autocomplete="off" id="inputInstantCardAddUserSearch" placeholder="' +
__e( i18next.t('Email or Username') ) +
'" name="email" class="js-search-users form-control input-sm" title="' +
__e( i18next.t('Email or Username') ) +
'"></div>\n\t\t\t\t\t\t\t\t\t </div>\n\t\t\t\t\t\t\t\t </div>\n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t</li>\n\t\t\t\t\t<li class="duedate">\n\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t<label for="calendar" class="control-label col-xs-12 text-right">' +
__e( i18next.t("Calendar") ) +
'</label>\n\t\t\t\t\t\t\t<div class="input-group">\n\t\t\t\t\t\t\t\t<span class="input-group-addon"><i class="icon-calendar cur js-instant-date text-muted"></i></span>\n\t\t\t\t\t\t\t\t<input type="text" id="calendar" class="form-control js-instant-duedate" name="due_date">\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</li>\n\t\t\t\t\t<li class="dropdown dropup">\n\t\t\t\t\t\t<a class="btn btn-link js-show-card-label-form" data-toggle="dropdown" title="' +
__e( i18next.t('Labels') ) +
'" href="#"><i class="icon-tag js-instant-label"></i></a>\n\t\t\t\t\t\t<ul class="dropdown-menu list-unstyled js-show-instant-card-label-form-response arrow arrow-bottom"></ul>\n\t\t\t\t\t</li>\n\t\t\t\t</ul>\n\t\t\t\t\n\t\t\t\t<div class="pull-right">\n\t\t\t\t\t<input type="submit" class="btn btn-primary" value="' +
__e( i18next.t('Save') ) +
'">\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t</div>\n</form>\n';
 };


}
return __p
};

this["JST"]["templates/instant_card_add_labels_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="col-xs-12 text-center clearfix"><span class="col-xs-10"><strong>' +
__e( i18next.t("Labels") ) +
'</strong></span><a href="#" class="js-close-popover pull-right "><i class="icon-remove"></i></a></div>\n<div class="col-xs-12 divider"></div>\n<div class="">\n\t<div class="col-xs-12 full-form">\n\t\t<input type="text" class="js-card-label" name="labels" />\n\t</div>\n</div>';

}
return __p
};

this["JST"]["templates/instant_card_add_members_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<input type="hidden" name="members" value="' +
__e( user_id ) +
'"/>';

}
return __p
};

this["JST"]["templates/label_delete_confirm"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\t\n\t<a href="#" class="js-show-labels pull-left"><i class="icon-caret-left "></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t("Delete Label?") ) +
'</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove "></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<p>' +
__e( i18next.t("There is no undo. This will remove this label from all cards and destroy its history.") ) +
'</p>\t\n\t<a class="js-label-confirm-delete btn  btn-primary" title="' +
__e( i18next.t('Delete') ) +
'">' +
__e( i18next.t("Delete") ) +
'</a>\n</div>';

}
return __p
};

this["JST"]["templates/list"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '\n\t<div class="list-header js-list-head ';
 if(!_.isUndefined(authuser.user)){;
__p += 'cur-grab';
};
__p += '">\n\t  <div class="clearfix">\n\t\t<a href="#" class="col-xs-8 ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(list.board.acl_links.where({slug: "edit_list",board_user_role_id: parseInt(list.board_user_role_id)})))){ ;
__p += 'js-show-edit-list-form';
 }else{ ;
__p += ' js-no-action';
};
__p += '"><span><span class="clearfix row show">\n\t\t';
 if(!_.isUndefined(TODO_COLOR) && !_.isUndefined(TODO_ICON)) { ;
__p += '\n\t\t\t';
 _.each(todo_lists, function(todo_list) { ;
__p += '\n\t\t\t\t';
 if(list.attributes.name.trim().toLowerCase() == todo_list.trim().toLowerCase()) { ;
__p += '\n\t\t\t\t\t<span><i class="' +
__e( TODO_ICON ) +
'" style="color:' +
__e( TODO_COLOR ) +
'" ></i></span>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t';
 }); ;
__p += '\n\t\t';
 } ;
__p += '\n\t\t';
 if(!_.isUndefined(DOING_COLOR) && !_.isUndefined(DOING_ICON)) { ;
__p += '\n\t\t\t';
 _.each(doing_lists, function(doing_list) { ;
__p += '\n\t\t\t\t';
 if(list.attributes.name.trim().toLowerCase() == doing_list.trim().toLowerCase()) { ;
__p += '\n\t\t\t\t\t<span><i class="' +
__e( DOING_ICON ) +
'" style="color:' +
__e( DOING_COLOR ) +
'"></i></span>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t';
 }); ;
__p += '\n\t\t';
 } ;
__p += '\n\t\t';
 if(!_.isUndefined(DONE_COLOR) && !_.isUndefined(DONE_ICON)) { ;
__p += '\n\t\t\t';
 _.each(done_lists, function(done_list) { ;
__p += '\n\t\t\t\t';
 if(list.attributes.name.trim().toLowerCase() == done_list.trim().toLowerCase()) { ;
__p += '\n\t\t\t\t\t<span><i class="' +
__e( DONE_ICON ) +
'" style="color:' +
__e( DONE_COLOR ) +
'"></i></span>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t';
 }); ;
__p += '\n\t\t';
 } ;
__p += '\n\t\t<strong>' +
__e( list.attributes.name ) +
'</strong></span></span>';
 var is_sub_class = 'hide'; if(!_.isEmpty(list.subscriber.attributes) && list.subscriber.attributes.is_subscribed == true){ is_sub_class = ''; };
__p += '<span class="pull-right"><i class="icon-eye-open js-list-subscribed-' +
__e( list.attributes.id ) +
' ' +
__e( is_sub_class ) +
'"></i></span></a>\n\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(list.board.acl_links.where({slug: "edit_list",board_user_role_id: parseInt(list.board_user_role_id)})))){ ;
__p += '\n\t\t<form role="form" class="form-horizontal js-edit-list hide">\n\t\t\t<div class="form-group">\n\t\t\t  <label class="col-sm-4 control-label hide" for="inputListName">' +
__e( i18next.t("Name") ) +
'</label>\n\t\t\t  <div class="col-sm-12">\n\t\t\t\t\t<input type="text" maxlength="255" autocomplete="off" id="inputListName" name="name" title="' +
__e( i18next.t('Whitespace alone not allowed') ) +
'" required pattern=".*\\S+.*" value="' +
__e( list.attributes.name ) +
'" class="form-control"/>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="form-group">\n\t\t\t\t<label class="sr-only col-sm-4 control-label hide" for="submit2">' +
__e( i18next.t("Submit") ) +
'</label>\n\t\t\t\t<div class="col-sm-12">\n\t\t\t\t\t<input type="submit" name="Save" class="btn btn-primary" value="' +
__e( i18next.t('Save') ) +
'" />\n\t\t\t\t\t<i class="icon-remove js-hide-edit-list-form btn btn-link cur" title="' +
__e( i18next.t('Cancel') ) +
'"></i>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</form>\n\t\t';
 } ;
__p += '\n\t\t';
if(!_.isUndefined(authuser.user)) {;
__p += '\n\t\t<div class="pull-right col-xs-4 clearfix">\n\t\t\t<div class="dropdown">\n\t\t\t<a href="#" class="dropdown-toggle pull-right js-show-list-actions" id="js-show-list-actions-' +
__e( list.attributes.id ) +
'" data-toggle="dropdown" title="' +
__e( i18next.t('List Actions') ) +
'" data-list-id="' +
__e( list.attributes.id ) +
'"><i class="icon-cog text-primary"></i></a>\n\t\t\t</div>\n\t\t\t<div class="dropdown right-mar">\n\t\t\t<a href="#" class="dropdown-toggle pull-right js-show-sort-form right-mar" id="js-show-sort-form-' +
__e( list.attributes.id ) +
'" data-toggle="dropdown" title="' +
__e( i18next.t('Sort') ) +
'" data-list-id="' +
__e( list.attributes.id ) +
'"><i class="icon-sort text-primary"></i></a>\n\t\t\t<ul class="dropdown-menu dropdown-menu-left arrow arrow-left dropdown-menu-top js-sort-list-response right-mar">\n\t\t\t\t <li class="text-center"><strong>' +
__e( i18next.t("Sort") ) +
'</strong></li>\n\t\t\t\t <li class="divider"></li>\n\t\t\t\t <li><a title="' +
__e( i18next.t('Votes') ) +
'" href="#" class="js-sort-by" data-sort-by="card_voter_count">' +
__e( i18next.t("Votes") ) +
'</a></li>\n\t\t\t\t <li><a title="' +
__e( i18next.t('Attachments') ) +
'" href="#" class="js-sort-by" data-sort-by="attachment_count">' +
__e( i18next.t("Attachments") ) +
'</a></li>\n\t\t\t\t <li><a title="' +
__e( i18next.t('Comments') ) +
'" href="#" class="js-sort-by" data-sort-by="comment_count">' +
__e( i18next.t("Comments") ) +
'</a>\n\t\t\t\t </li>\n\t\t\t\t <li><a title="' +
__e( i18next.t('Checklist pending count') ) +
'" href="#" class="js-sort-by" data-sort-by="checklist_item_count">' +
__e( i18next.t("Checklist pending count") ) +
'</a>\n\t\t\t\t </li>\n\t\t\t\t <li><a title="' +
__e( i18next.t('Checklist completed count') ) +
'" href="#" class="js-sort-by" data-sort-by="checklist_item_completed_count">' +
__e( i18next.t("Checklist completed count") ) +
'</a>\n\t\t\t\t </li>\n\t\t\t\t <li><a title="' +
__e( i18next.t('Due date') ) +
'" href="#" class="js-sort-by" data-sort-by="due_date">' +
__e( i18next.t("Due date") ) +
'</a>\n\t\t\t\t </li>\n\t\t\t </ul>\n\t\t\t</div>\n\t\t</div>\n\t\t';
 } ;
__p += '\n\t  </div>\n\t</div>\n\t<div class="list-content vertical-scrollbar vertical-scrollbar-box js-board-list-cards" id="js-card-listing-' +
__e( list.attributes.id ) +
'">\n\t</div>\n\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(list.board.acl_links.where({slug: "add_card",board_user_role_id: parseInt(list.board_user_role_id)})))){ ;
__p += '\n\t\t<div class="list-footer clearfix">\n\t\t\t<div class="pull-left"><a href="#" title="' +
__e( i18next.t('Add a card') ) +
'" class="js-show-add-card-form js-bottom text-muted">' +
__e( i18next.t("Add a card") ) +
'</a></div>\n<div class="js-card-add-form-' +
((__t = ( list.attributes.id )) == null ? '' : __t) +
'"></div>\t\t\t\n\t\t</div>\n\t';
 } ;
__p += '\t\n  ';

}
return __p
};

this["JST"]["templates/list_actions"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {


	var is_subscribed = '<i class="icon-ok hide"></i>';
    var subscribe_class = 'js-list-subscribe';
	var subscribe = subscribers.findWhere({
		 user_id: parseInt(authuser.id),
		 is_subscribed: 1
	 });
	 var subscribe_id = '';
	 if (!_.isEmpty(subscribe) && parseInt(subscribe.attributes.is_subscribed) === 1) {
		 is_subscribed = '<i class="icon-ok"></i>';
		 subscribe_class = 'js-list-unsubscribe';
		 subscribe_id = subscribe.attributes.id;
	 }
;
__p += '\n<li class="text-center"><strong>' +
__e( i18next.t("List Actions") ) +
'</strong><a class="pull-right"><i class=" icon-remove"></i></a></li>\n<li class="divider"></li>\n';
 if(!_.isUndefined(authuser) && (authuser.role_id == 1 || !_.isEmpty(list.collection.board.acl_links.where({slug: "add_card",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t<li><a href="#" title="' +
__e( i18next.t('Add Card') ) +
'" class="js-show-add-card-form">' +
__e( i18next.t("Add Card") ) +
'</a></li>\n';
 } ;
__p += '\t\n';
 if(!_.isUndefined(authuser) && (authuser.role_id == 1 || !_.isEmpty(list.collection.board.acl_links.where({slug: "add_list",board_user_role_id: parseInt(list.board_user_role_id)}))) && !is_offline_data){ ;
__p += '\n\t<li class="js-hide-on-offline"><a href="#" title="' +
__e( i18next.t('Copy List') ) +
'" class="js-show-copy-list-form">' +
__e( i18next.t("Copy List") ) +
'</a></li>\n';
 } ;
__p += '\t\n';
 if(!_.isUndefined(authuser) && (authuser.role_id == 1 || !_.isEmpty(list.collection.board.acl_links.where({slug: "edit_list",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t<li><a href="#" title="' +
__e( i18next.t('Move List') ) +
'" class="js-show-move-list-form" data-list-id="' +
__e( list.id ) +
'">' +
__e( i18next.t("Move List") ) +
'</a></li>\n';
 } ;
__p += '\n';
 if(!_.isUndefined(authuser) && (authuser.role_id == 1 || (((!_.isEmpty(list.collection.board.acl_links.where({slug: "subscribe_list",board_user_role_id: parseInt(list.board_user_role_id)})) && _.isEmpty(subscribe)) || (!_.isEmpty(list.collection.board.acl_links.where({slug: "unsubscribe_list",board_user_role_id: parseInt(list.board_user_role_id)})) && !_.isEmpty(subscribe)))  || (!_.isEmpty(role_links.where({slug: "subscribe_list"})) && list.collection.board.attributes.board_visibility == 2)))){ ;
__p += '\n\t';

		var subscribe_disabled = '';
		var subscribe_title = i18next.t('Subscribe');
		var subscribed = list.collection.board.board_subscribers.findWhere({
			user_id: parseInt(authuser.id),
			is_subscribed: 1
		});
		if (subscribed) {
			subscribe_disabled = 'disabled';
			subscribe_title = i18next.t('Board wise subscription already enabled');
		}
	;
__p += '\n\t<li class="' +
((__t = ( subscribe_disabled )) == null ? '' : __t) +
'"><a href="#" title="' +
__e( subscribe_title ) +
'" class="highlight-icon ' +
((__t = ( subscribe_class )) == null ? '' : __t) +
'" data-list-id="' +
__e( list.id ) +
'" data-subscribe-id="' +
__e( subscribe_id ) +
'"><span class="js-subscribe-text">' +
__e( i18next.t("Subscribe") );
if (!_.isEmpty(subscribe) && parseInt(subscribe.attributes.is_subscribed) === 1) {;

};
__p += '</span> ' +
((__t = ( is_subscribed )) == null ? '' : __t) +
'</a></li>\n';
 } ;
__p += '\t\n<li class="divider"></li>\n';
 if(!_.isUndefined(authuser) && (authuser.role_id == 1 || !_.isEmpty(list.collection.board.acl_links.where({slug: "move_list_cards",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t<li><a href="#" title="' +
__e( i18next.t('Move All Cards in This List') ) +
'" class="js-show-move-card-list-form" data-list-id="' +
__e( list.id ) +
'">' +
__e( i18next.t("Move All Cards in This List") ) +
'</a></li>\n';
 } ;
__p += '\n';
 if(!_.isUndefined(authuser) && (authuser.role_id == 1 ||  !_.isEmpty(list.collection.board.acl_links.where({slug: "edit_list",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t<li><a href="#" title="' +
__e( i18next.t('Archive All Cards in this List') ) +
'" class="js-show-confirm-archive-cards" data-list-id="' +
__e( list.id ) +
'">' +
__e( i18next.t("Archive All Cards in this List") ) +
'</a></li>\n';
 } ;
__p += '\n<li class="divider"></li>\n<li><a href="#" title="' +
__e( i18next.t('Show Attachments') ) +
'" class="js-show-list-modal">' +
__e( i18next.t("Show Attachments") ) +
'</a></li>\n';
 if(!_.isUndefined(authuser) && (authuser.role_id == 1 || !_.isEmpty(list.collection.board.acl_links.where({slug: "archive_list",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t<li><a href="#" title="' +
__e( i18next.t('Archive This List') ) +
'" class="js-show-confirm-archive-list" data-list-id="' +
__e( list.id ) +
'">' +
__e( i18next.t("Archive This List") ) +
'</a></li>\n';
 } ;
__p += '\n';
 if(!_.isUndefined(authuser) && (authuser.role_id == 1 ||  !_.isEmpty(list.collection.board.acl_links.where({slug: "delete_list",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n<li><a href="#" title="' +
__e( i18next.t('Delete this List') ) +
'" class="js-show-confirm-list-delete" data-list-id="' +
__e( list.id ) +
'"><i class="icon-sm icon-warning-sign icon-type text-primary"></i>' +
__e( i18next.t("Delete this List") ) +
'</a></li>\n';
 } ;


}
return __p
};

this["JST"]["templates/list_add"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="list js-list-form well ">\n\t<a href="#" class="js-show-add-list-form toggle-show text-muted" title="' +
__e( i18next.t('Add a list') ) +
'">' +
__e( i18next.t("Add a list") ) +
'</a>\n\t<span class="hide"></span>\n\t<form class="js-add-list">\n\t\t<div class="form-group required">\n\t\t\t<label for="inputListName" class="hide">' +
__e( i18next.t("Name") ) +
'</label>\n\t\t\t<input maxlength="255" type="text" id="inputListName" name="name" autocomplete="off" class="form-control input-sm"placeholder="Add a list" required />\n\t\t</div>\n\t\t<div class="submit">\n\t\t\t\n\t\t\t<input type="submit" name="Save" class="btn btn-primary" value="Save"/>\n\t\t\t<i class="icon-remove js-hide-add-list-form btn btn-link cur" title="' +
__e( i18next.t('Cancel') ) +
'"></i>\n\t\t</div>\n\t</form>\n</div>';

}
return __p
};

this["JST"]["templates/list_archive_confirm"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\n\t<a href="#" class="js-back-to-list-actions pull-left" data-list-id="' +
__e( list.id) +
'"><i class="icon-caret-left "></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t("Archive This List") ) +
'</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove "></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<p>' +
__e( i18next.t('This will remove list from the board. To view archived lists and bring them back to the board, click "Settings" > "Archived Items" > "Switch to lists".') ) +
'</p>\n\t<a class="js-archive-list btn  btn-primary" title="' +
__e( i18next.t('Archive') ) +
'" data-list-id="' +
__e( list.id) +
'">' +
__e( i18next.t("Archive") ) +
'</a>\n</div>';

}
return __p
};

this["JST"]["templates/list_cards_archive_confirm"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\t\n\t\t<a href="#" class="js-back-to-list-actions pull-left" data-list-id="' +
__e( list.id) +
'"><i class="icon-caret-left "></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t("Archive All Cards in this List") ) +
'?</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove "></i></a></span></h4>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<p>' +
__e( i18next.t('This will remove all the cards in this list from the board. To view archived cards and bring them back to the board, click "Menu" > "Archived Items".') ) +
' </p>\n\t<a class="js-archive-card btn  btn-primary" title="' +
__e( i18next.t('Archive All') ) +
'" data-list-id="' +
__e( list.id) +
'">' +
__e( i18next.t("Archive All") ) +
'</a>\n</div>';

}
return __p
};

this["JST"]["templates/list_delete_confirm"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\t\n\t<a href="#" class="js-back-to-list-actions pull-left" data-list-id="' +
__e( list.id ) +
'"><i class="icon-caret-left "></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t("Delete this List") ) +
'</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove "></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<p>' +
__e( i18next.t("This will remove list from the board. You can't undo the list after delete.") ) +
'</p>\t\n\t<a class="js-delete-list btn  btn-primary" title="' +
__e( i18next.t('Delete List') ) +
'" data-list-id="' +
__e( list.id ) +
'">' +
__e( i18next.t("Delete") ) +
'</a>\n</div>';

}
return __p
};

this["JST"]["templates/login"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 col-lg-offset-4 col-md-offset-4 col-sm-offset-3">\n\t<div class="panel panel-default">\n\t\t <div class="panel-heading lead">\n\t\t\t' +
__e( i18next.t('Login') ) +
'\n\t\t </div>\n\t\t <div class="panel-body well-lg">\n\t\t\t<form class="form-horizontal clearfix col-xs-12" role="form" name="UserLoginForm" id="UserLoginForm">\n\t\t\t\t<div class="form-group">\n\t\t\t\t\t';
 
					   if (!_.isEmpty(LDAP_LOGIN_ENABLED) && LDAP_LOGIN_ENABLED == "true" && !_.isEmpty(STANDARD_LOGIN_ENABLED) && STANDARD_LOGIN_ENABLED === "true") {
							loginPlaceholder = i18next.t('Email or Username or LDAP Login');
					   } else if (!_.isEmpty(LDAP_LOGIN_ENABLED) && LDAP_LOGIN_ENABLED == "true") {
							loginPlaceholder = i18next.t('LDAP Login');
					   } else {
							loginPlaceholder = i18next.t('Email or Username');
					   }
					;
__p += '\n\t\t\t\t  <label for="inputEmail" class="sr-only control-label">' +
__e( i18next.t('Email or Username') ) +
'</label>\n\t\t\t\t  <input type="text" placeholder="' +
((__t = ( loginPlaceholder )) == null ? '' : __t) +
'" class="form-control" id="inputEmail" name="email"  title="' +
((__t = ( loginPlaceholder )) == null ? '' : __t) +
'" required/>\n\t\t\t\t</div>\n\t\t\t\t<div class="form-group">\n\t\t\t\t  <label for="inputPassword" class="sr-only control-label">' +
__e( i18next.t('Password') ) +
'</label>\n\t\t\t\t  <input type="password" placeholder="' +
__e( i18next.t('Password') ) +
'" class="form-control" id="inputPassword" name="password" title="' +
__e( i18next.t('Password') ) +
'" required/>\n\t\t\t\t</div>\n\t\t\t\t<div class="form-group">\n\t\t\t\t  <label for="submit2" class="sr-only control-label">' +
__e( i18next.t('Login') ) +
'</label>\n\t\t\t\t  <input type="submit" class="btn btn-primary col-xs-12" value="' +
__e( i18next.t('Login') ) +
'" id="submitLogin" />\n\t\t\t\t</div>\n\t\t\t\t<ul class="list-inline small text-center">\n\t\t\t\t  ';
 if(!_.isEmpty(role_links.where({slug: "users_forgotpassword"}))){ ;
__p += '\n\t\t\t\t\t<li><a href="#/users/forgotpassword" title="' +
__e( i18next.t('Forgot your password') ) +
'?" class="text-primary">' +
__e( i18next.t('Forgot your password') ) +
'?</a></li>\n\t\t\t      ';
 } ;
__p += '\n\t\t\t\t</ul>\n\t\t  </form>\n\t\t </div>\n\t</div>\n</div>';

}
return __p
};

this["JST"]["templates/modal_activity_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="modal fade" id="modalActivityView" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">\n\t<div class="modal-dialog">\n\t\t  <div class="modal-content">\n\t\t\t<div class="modal-header clearfix">\n\t\t\t  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>\n\t\t\t  <span class="col-xs-10"><strong>';
 if(type == 'board'){ ;
__p +=
__e( i18next.t('Board') );
}else{ ;
__p +=
__e( i18next.t('User') );
};
__p +=
__e( i18next.t('Activity') ) +
'</strong></span>\t\t\t  \n\t\t\t</div>\t\t\t\n\t\t\t<div class="modal-body scrollbar clearfix">\t\t\t\t\t\t\t\t\t\t\t\t\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<ul class="list-unstyled" id="js-activities-list"></ul>\n\t\t\t\t</div>\n\t\t\t\t<div class="clearfix text-center">\n\t\t\t\t<a href="#" class="js-load-more hide">' +
__e( i18next.t('Load more activities') ) +
'</a>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t  </div><!-- /.modal-content -->\n    </div>\n</div>';

}
return __p
};

this["JST"]["templates/modal_card_member_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li class="clearfix text-center col-xs-12">\n\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Members') ) +
'</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove"></i></a>\t\t\n</li>\n<li class="col-xs-12 divider"></li>\n';

	board_users.each(function(board_user) {
	var added_user = users.findWhere({
		card_id: card.id,
		user_id: board_user.get('user_id')
	});
	if (_.isUndefined(added_user)) {
;
__p += '\n\t   <li><a href="#" class="highlight-icon js-add-card-member" data-toggle="tooltip" title="' +
__e(board_user.attributes.full_name ) +
' (' +
__e(board_user.attributes.username ) +
')" data-user-id="' +
__e( board_user.get('user_id') ) +
'" data-user-name="' +
__e( board_user.get('username') ) +
'" data-user-fullname="' +
__e(board_user.get('full_name') ) +
'" data-user-initial="' +
__e(board_user.get('initials') ) +
'" data-user-profile-picture-path="' +
__e(board_user.get('profile_picture_path') ) +
'" >' +
__e(  board_user.get('username') ) +
'</a></li>\n  ';
  } else { ;
__p += '\n\t\t<li><a href="#" class="highlight-icon js-remove-card-member" data-card-user-id="' +
__e(  added_user.id ) +
'"><i class="avatar avatar-color-194 img-rounded" title="' +
__e(  board_user.get('full_name') ) +
' (' +
__e(  board_user.get('username') ) +
')">' +
__e(board_user.get('initials') ) +
'' +
__e(board_user.get('username') ) +
'</i></a> <i class="icon-ok"></i></li>\n';
  }
}); ;
__p += ' ';

}
return __p
};

this["JST"]["templates/modal_card_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<section class="row js-card-dock-modal-' +
__e( card.attributes.id ) +
' js-card-container" id="dropzone' +
__e( card.attributes.id ) +
'">\n  <div class="pull-right js-attachment-loader"></div>\n  <div class="clearfix col-xs-12">\n  <h3 class="navbar-btn"> <span class="icon-credit-card text-muted"></span> <a href="" title="' +
__e( card.attributes.name ) +
'" class="';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "edit_card",board_user_role_id: parseInt(list.board_user_role_id)})))){ ;
__p += 'js-show-card-title-edit-form';
 }else{ ;
__p += ' js-no-action';
};
__p += '">' +
__e( card.attributes.name ) +
'</a><small>' +
__e( i18next.t('in list') ) +
'</small><span class="dropdown"><a class="dropdown-toggle ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: 'move_list_cards',board_user_role_id: parseInt(list.board_user_role_id)})))){ ;
__p += 'js-show-move-card-form';
}else{;
__p += 'js-no-action';
};
__p += '" data-toggle="dropdown" title="' +
__e( list.attributes.name ) +
'" href="#">' +
__e( list.attributes.name ) +
'</a>\n  ';
 if(!_.isUndefined(authuser.user)){ ;
__p += '\n\t<ul class="dropdown-menu arrow col-xs-12 panel-body">\n\t\t<li class="col-xs-12 clearfix text-center"><div> <span class="col-xs-10"><strong>' +
__e( i18next.t('Move Card') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div></li>\n\t\t<li class="col-xs-12 divider"></li>\n\t\t<li class="col-xs-12">\n\t\t<form role="form" class="js-move-card" name="MoveCardForm" id="MoveCardForm">\n\t\t  <div class="js-show-move-card-form-response"> </div>\n\t\t  <div class="form-group clearfix panel-body">\n\t\t\t<label class="sr-only">' +
__e( i18next.t('Move') ) +
'</label>\n\t\t\t<input type="submit" id="submitListMove" class="btn btn-primary col-xs-12" value="' +
__e( i18next.t('Move') ) +
'" />\n\t\t  </div>\n\t\t</form>\n\t  </li>\n\t</ul>\n\t';
 } ;
__p += '\n\t</span>\n\t';

		if(!_.isUndefined(authuser) && !_.isUndefined(authuser.user)){
			var cards_subscribers = card.cards_subscribers.where({
				is_subscribed: 1,
				user_id: parseInt(authuser.user.id)
			});
		}
		
		var subscribed = '';
		if(!_.isUndefined(cards_subscribers) && !_.isEmpty(cards_subscribers)){
	 ;
__p += '\n\t<span class="icon-eye-open"></span>\n\t';
 } ;
__p += '\n  </h3>\n  <div class="clearfix navbar-btn row">\n\t  <div class="splitter-wrap editor ui-resizable" >\n\t\t<div class="col-xs-12">\n\t\t\t<ul class="list-unstyled navbar-btn row">\n\t\t\t  <li class="list-group-item list-group-item-info clearfix">\n\t\t\t\t<div class="list-group-item-heading">\n\t\t\t\t  \n\t\t\t\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "edit_card",board_user_role_id: parseInt(list.board_user_role_id)})))){ ;
__p += '\n\t\t\t\t  <form role="form" class="form-horizontal hide js-card-edit-form" name="cardTitleEditForm" id="cardTitleEditForm">\n\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t  <div class="col-sm-11">\n\t\t\t\t\t\t<textarea rows="4" id="inputCardName" name="name" required  class="form-control">' +
__e( card.attributes.name ) +
'</textarea>\n\t\t\t\t\t  </div>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t  <div class="col-sm-8">\n\t\t\t\t\t\t<input type="submit" value="' +
__e( i18next.t('Save') ) +
'" id="submitCardTitleEditForm" class="btn btn-primary">\n\t\t\t\t\t\t<a class="js-cancel-card-title-edit btn btn-link"><i class="icon-remove"></i></a> </div>\n\t\t\t\t\t</div>\n\t\t\t\t  </form>\n\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t</div>\n\t\t\t\t<ul class="list-group-item-text list-inline clearfix">\n\t\t\t\t  <li class="mar-bottom">\n\t\t\t\t\t<h4 class="text-muted list-group-item-heading">' +
__e( i18next.t('Members') ) +
'</h4>\n\t\t\t\t\t<ul class="list-inline clearfix" id="js-card-users-list-' +
__e( card.attributes.id ) +
'">\n\t\t\t\t\t';
 if(!_.isUndefined(authuser.user)){ ;
__p += '\n\t\t\t\t\t  <li id="js-card-user-add-container">\n\t\t\t\t\t\t<div class="dropdown js-member-dropdown"> \n\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "add_card_user",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t<a class="dropdown-toggle js-show-add-member-form btn btn-default" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Add Member') ) +
'" href="#"> <i class="icon-plus"></i> </a>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12">\n\t\t\t\t\t\t\t<li> <div class="clearfix text-center col-xs-12"><span class="col-xs-10"><strong>' +
__e( i18next.t('Members') ) +
'</strong></span><i class="icon-remove cur"></i></div></li>\n\t\t\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t\t\t  <form method="post" class="text-center" name="addMember">\n\t\t\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t\t  <label class="sr-only">' +
__e( i18next.t('Search Member') ) +
'</label>\n\t\t\t\t\t\t\t\t  <input type="text" autocomplete="off" id="inputOrganizationUserSearch" placeholder="' +
__e( i18next.t('Search Members') ) +
'" name="email" required class="js-search-users form-control input-sm" title="' +
__e( i18next.t('Search Members') ) +
'">\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t  </form>\n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t<li class="js-organization-member-search-response col-xs-12 small">' +
__e( i18next.t('Search for a person in %s by name or email address.', { postProcess: 'sprintf', sprintf: [SITE_NAME] }) ) +
'</li>\n\t\t\t\t\t\t  </ul>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t  </li>\n\t\t\t\t\t  ';
};
__p += '\n\t\t\t\t\t</ul>\n\t\t\t\t  </li>\n\t\t\t\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "view_card_labels",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t  <li class="mar-bottom">\n\t\t\t\t\t<h4 class="text-muted list-group-item-heading">' +
__e( i18next.t('Labels') ) +
'</h4>\n\t\t\t\t\t<ul class="list-inline clearfix js-card-labels-list">\n\t\t\t\t\t';
 if(!_.isUndefined(authuser.user)){ ;
__p += '\n\t\t\t\t\t  <li>\n\t\t\t\t\t\t<div class="dropdown js-label-dropdown">\n\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "delete_labels",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t\t<a class="dropdown-toggle js-show-card-label-form btn btn-default" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Add new Labels') ) +
'" href="#"> <i class="icon-plus"></i></a>';
 } ;
__p += '\n\t\t\t\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12 js-show-card-label-form-response">\n\t\t\t\t\t\t  </ul>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t  </li>\n\t\t\t\t\t  ';
};
__p += '\n\t\t\t\t\t</ul>\n\t\t\t\t  </li>\n\t\t\t\t  ';
 } ;
__p += ' \n\t\t\t\t  ';
 if (!_.isEmpty(card.card_voters)) { ;
__p += '\n\t\t\t\t\t  <li class="mar-bottom">\n\t\t\t\t\t\t<h4 class="text-muted list-group-item-heading">' +
__e( i18next.t('Votes') ) +
'</h4>\n\t\t\t\t\t\t<ul class="list-inline clearfix">\n\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "vote_card",board_user_role_id: parseInt(list.board_user_role_id)})) || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "unvote_card",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t<li>\n\t\t\t\t\t\t\t  ';
 if(!_.isUndefined(authuser) && !_.isUndefined(authuser.user)){
									var voted_user = card.card_voters.findWhere({
									 user_id: parseInt(authuser.user.id)
								}); 
							;
__p += '\n\t\t\t\t\t\t\t';
 if(_.isEmpty(voted_user)){  ;
__p += '\n\t\t\t\t\t\t\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "vote_card",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t\t  <button type="button" class="btn btn-primary js-add-card-vote"><i class=" icon-thumbs-up"></i></button> \n\t\t\t\t\t\t\t  ';
 } ;
__p += '  \n\t\t\t\t\t\t\t  ';
 } else{ ;
__p += '\n\t\t\t\t\t\t\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "unvote_card",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t\t  <button type="button" class="btn btn-default active js-delete-card-vote"><i class="  icon-thumbs-up"></i></button>  \n\t\t\t\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t\t\t\t  ';
 } };
__p += '         \n\t\t\t\t\t   </li>\n\t\t          ';
 } ;
__p += '\n\t\t\t\t\t  \n\t\t\t\t\t  <li class="dropdown"><a href="#" title="' +
__e( i18next.t('Add Vote') ) +
'" class="btn btn-default js-show-card-voters-list dropdown-toggle" data-toggle="dropdown">' +
__e( i18next.t('{{count}} Vote', {count: card.card_voters.length}) ) +
'</a>\n\t\t\t\t\t\t<ul class="dropdown-menu dropdown-menu-left arrow js-show-card-voters-list-response">\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t  </li>\n\t\t\t\t\t</ul>\n\t\t\t\t  </li>\n\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "edit_card",board_user_role_id: parseInt(list.board_user_role_id)})))){ ;
__p += '\n\t\t\t\t  ';
 if(!_.isEmpty(card.attributes.due_date) && card.attributes.due_date != 'NULL') { ;
__p += '\n\t\t\t\t  <li class="">\n\t\t\t\t\t<h4 class="text-muted list-group-item-heading">' +
__e( i18next.t('Due Date') ) +
'</h4>\n\t\t\t\t\t<ul class="list-inline clearfix">\n\t\t\t\t\t';
 
						var date_time = card.attributes.due_date.split('T');
						date_time = date_time[0].split(' ');
					;
__p += '\n\t\t\t\t\t  <li class="dropdown"> <a class="btn btn-default dropdown-toggle ';
 if(!_.isUndefined(authuser.user)){ ;
__p += 'js-edit-card-due-date-form';
}else{;
__p += 'js-no-action ';
};
__p += '" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Due Date') ) +
'" href="#">' +
((__t = ( dateFormat(date_time[0], 'mediumDate')  )) == null ? '' : __t) +
'</a>\n\t\t\t\t\t  ';
 if(!_.isUndefined(authuser.user)){ ;
__p += '\n\t\t\t\t\t\t<ul class="dropdown-menu arrow col-xs-12 panel-body">\n\t\t\t\t\t\t  <li>\n\t\t\t\t\t\t\t<h4 class="text-center">' +
__e( i18next.t('Due Date') ) +
'</h4>\n\t\t\t\t\t\t  </li>\n\t\t\t\t\t\t  <li class="divider"></li>\n\t\t\t\t\t\t  <li class="js-edit-card-due-date-form-response">\n\t\t\t\t\t\t\t<form class="form-horizontal clearfix js-card-edit-form" name="cardDueDateEditForm" id="cardDueDateEditForm">\n\t\t\t\t\t\t\t</form>\n\t\t\t\t\t\t  </li>\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t  </li>\n\t\t\t\t\t</ul>\n\t\t\t\t  </li>\n\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t</ul>\n\t\t\t\t\t<div class="list-group-item-text clearfix">\n\t\t\t\t\t  <h4 class="text-muted">' +
__e( i18next.t('Description') ) +
' \n\t\t\t\t\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "edit_card",board_user_role_id: parseInt(list.board_user_role_id)})))){ ;
__p += '\n\t\t\t\t\t\t  <a href="#" class="';
if(!_.isUndefined(authuser.user)) {;
__p += 'js-show-card-desc-edit-form';
}else{;
__p += 'js-no-action';
};
__p += '" title="' +
__e( i18next.t('Edit') ) +
'">\n\t\t\t\t\t  ';
if(!_.isUndefined(authuser.user)) {;
__p += '\n\t\t\t\t\t\t<i class="icon-pencil"></i>\n\t\t\t\t\t   ';
 } ;
__p += '\n\t\t\t\t\t  </a>\n\t\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t\t  </h4>\n\t\t\t\t\t  ';
 if(!_.isEmpty(card.attributes.description)){ ;
__p += '\n\t\t\t\t\t  <p class="js-show-card-desc">' +
((__t = ( converter.makeHtml(_.escape(card.attributes.description)) )) == null ? '' : __t) +
'</p>\n\t\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t\t   ';
if(!_.isUndefined(authuser.user)) {;
__p += '\n\t\t\t\t\t  <form class="hide js-card-edit-form" name="cardDescriptionEditForm" id="cardDescriptionEditForm">\n\t\t\t\t\t\t<div class="form-group required">\n\t\t\t\t\t\t  <textarea rows="4" id="inputCarddescription" name="description" class="form-control" required>' +
__e( card.attributes.description ) +
'</textarea>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<div class="submit panel-body">\n\t\t\t\t\t\t  <input type="submit" value="' +
__e( i18next.t('Save') ) +
'" id="submitCardDescriptionEditForm" class="btn btn-primary">\n\t\t\t\t\t\t  <a class="js-cancel-card-description-edit"><i class="icon-remove btn btn-link"></i></a> </div>\n\t\t\t\t\t  </form>\n\t\t\t\t\t  ';
 };
__p += '\n\t\t\t\t\t</div>\n\n\t\t\t\t<div id="js-card-checklists"></div>\n\t\t\t\t';
 if(!_.isEmpty(card.attachments)){ ;
__p += '\n\t\t\t\t<div class="list-group-item-heading clearfix">\n\t\t\t\t  <h3 class="pull-left"> <span class="pull-left"><i class="icon-paper-clip lead"></i></span>' +
__e( i18next.t('Attachment') ) +
'</h3>\n\t\t\t\t</div>\n\t\t\t\t<div class="list-group-item-text clearfix">\n\t\t\t\t  <ul class="list-unstyled clearfix attachment-list" id="js-card-attachments-list"></ul>\n\t\t\t\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "add_card_attachment",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t  <div class="clearfix dropdown"> \n\t\t\t\t  ';
 if(!_.isUndefined(authuser.user)){;
__p += '\n\t\t\t\t  <a class="dropdown-toggle btn-link h4 js-load-dropbox" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Add an attachment') ) +
'" href="#"> <span class="text-muted panel-title" >' +
__e( i18next.t('Add an attachment') ) +
'</span> </a>\n\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t\t<ul class="dropdown-menu arrow col-xs-3">\n\t\t\t\t\t\t<li class="col-xs-12 clearfix text-center"> <div><span class="col-xs-10"><strong>' +
__e( i18next.t('Attach From...') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div> </li>\n\t\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t<li class="col-xs-12"><a href="#" title="' +
__e( i18next.t('Computer') ) +
'" class="js-attachment-computer-open row">' +
__e( i18next.t('Computer') ) +
'</a></li>\n\t\t\t\t\t\t<li class="col-xs-12"><a href="#" title="' +
__e( i18next.t('Dropbox') ) +
'" class="js-attachment-dropbox-open row">' +
__e( i18next.t('Dropbox') ) +
'</a></li>\n\t\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t\t  <span class="col-xs-10 sr-only">' +
__e( i18next.t('Attach a Link') ) +
'</span>\n\t\t\t\t\t\t  <form class="js-card-attachment-link-form col-xs-12" method="post" role="form">\n\t\t\t\t\t\t\t<div class="form-group row">  \n\t\t\t\t\t\t\t  <input type="url" id="AttachList" class="form-control input-sm" name="image_link" placeHolder="' +
__e( i18next.t('Paste any link here') ) +
'" title="' +
__e( i18next.t('Whitespace alone not allowed') ) +
'" required pattern=".*\\S+.*">\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div class="form-group row">\n\t\t\t\t\t\t\t  <input type="submit" value="' +
__e( i18next.t('Submit') ) +
'" id="submit2" class="btn btn-primary btn-sm">\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<span class="help-block row small">' +
__e( i18next.t('Tip: You can drag and drop files and links onto cards to upload them.') ) +
'</span>\n\t\t\t\t\t\t  </form>\n\t\t\t\t\t  </li>\n\t\t\t\t\t</ul>\n\t\t\t\t  </div>\n\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t</div>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t';
 if(!_.isUndefined(authuser.user)) { ;
__p += '\n\t\t\t\t<div class="list-group-item-text clearfix">\t\n\t\t\t\t\t<div class="col-xs-12 row">\n\t\t\t\t\t  <h3 class="pull-left">' +
__e( i18next.t('Actions') ) +
'</h3>\n\t\t\t\t    </div>\n\t\t\t\t<ul class="js-card-actions list-inline navbar-btn">\n\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "move_list_cards",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t<li class="dropdown navbar-btn"> <a class="btn btn-default dropdown-toggle js-show-move-card-form js-card-header-action even-action" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Move') ) +
'" href="#"><i class="icon-folder-close"></i>' +
__e( i18next.t('Move') ) +
'</a>\n\t\t\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12">\n\t\t\t\t\t\t<li class="col-xs-12 clearfix text-center"><div> <span class="col-xs-10"><strong>' +
__e( i18next.t('Move Card') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div></li>\n\t\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t\t  <form role="form" class="js-move-card" name="MoveCardForm" id="MoveCardForm">\n\t\t\t\t\t\t\t<div class="js-show-move-card-form-response"> </div>\n\t\t\t\t\t\t\t<div class="form-group clearfix panel-body">\n\t\t\t\t\t\t\t  <label class="sr-only">' +
__e( i18next.t('Move') ) +
'</label>\n\t\t\t\t\t\t\t  <input type="submit" id="submitListMove" class="btn btn-primary col-xs-12" value="' +
__e( i18next.t('Move') ) +
'" />\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t  </form>\n\t\t\t\t\t\t</li>\n\t\t\t\t\t  </ul>\n\t\t\t\t\t</li>\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "copy_card",board_user_role_id: parseInt(list.board_user_role_id)})))  && !is_offline_data){ ;
__p += '\n\t\t\t\t\t\t<li class="dropdown js-hide-on-offline navbar-btn"> <a class="btn btn-default dropdown-toggle js-show-copy-card-form even-action" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Copy') ) +
'" href="#"><i class="icon-copy"></i>' +
__e( i18next.t('Copy') ) +
'</a>\n\t\t\t\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12 pre-scrollable vertical-scrollbar">\n\t\t\t\t\t\t\t<li class="col-xs-12 clearfix text-center"> <div><span class="col-xs-10"><strong>' +
__e( i18next.t('Copy Card') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div> </li>\n\t\t\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t\t\t  <form role="form" method="post" class="js-copy-card">\n\t\t\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t\t  <label for="card-title">' +
__e( i18next.t('Title') ) +
'</label>\n\t\t\t\t\t\t\t\t  <textarea id="card-title" class="form-control" rows="4" name="name">' +
__e( card.attributes.name) +
'</textarea>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t<div class="js-show-copy-card-form-response"> </div>\n\t\t\t\t\t\t\t\t<div class="form-group clearfix panel-body">\n\t\t\t\t\t\t\t\t  <label class="sr-only">' +
__e( i18next.t('Create card') ) +
'</label>\n\t\t\t\t\t\t\t\t  <input type="submit" class="btn btn-primary col-xs-12" value="' +
__e( i18next.t('Create card') ) +
'">\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t  </form>\n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t  </ul>\n\t\t\t\t\t\t</li>\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || (((!_.isEmpty(card.list.collection.board.acl_links.where({slug: "subscribe_card",board_user_role_id: parseInt(list.board_user_role_id)})) && _.isEmpty(cards_subscribers)) || (!_.isEmpty(card.list.collection.board.acl_links.where({slug: "unsubscribe_card",board_user_role_id: parseInt(list.board_user_role_id)})) && !_.isEmpty(cards_subscribers)))  || (!_.isEmpty(role_links.where({slug: "subscribe_card"})) && card.list.collection.board.attributes.board_visibility == 2)))) { ;
__p += '\n\t\t\t\t\t\t';

							var subscribe_disabled = '';
							var subscribe_title = i18next.t('Subscribe');
							var subscribed = card.list.collection.board.board_subscribers.findWhere({
								user_id: parseInt(authuser.user.id),
								is_subscribed: 1
							}); 
							if (subscribed) {
								subscribe_disabled = 'disabled';
								subscribe_title = i18next.t('Board wise subscription already enabled');
							}
						;
__p += '\n\t\t\t\t\t\t<li class="' +
((__t = ( subscribe_disabled )) == null ? '' : __t) +
' navbar-btn"> \n\t\t\t\t\t\t\t<a class="btn btn-default ';
 if(!_.isEmpty(cards_subscribers)){;
__p += ' js-card-unsubscribe ';
 } else {;
__p += 'js-card-subscribe ';
 };
__p += ' even-action" title="' +
__e( subscribe_title ) +
' " href="">\n\t\t\t\t\t\t\t';
 if(!_.isEmpty(cards_subscribers)){ ;
__p += '\n\t\t\t\t\t\t\t\t<i class="icon-eye-open"></i>\n\t\t\t\t\t\t    ';
 } else { ;
__p += '\n\t\t\t\t\t\t\t\t<i class="icon-eye-close"></i>\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t' +
__e( i18next.t('Subscribe') ) +
'\n\t\t\t\t\t\t\t</a> \n\t\t\t\t\t  </li>\n\t\t\t\t   ';
 } ;
__p += '\n\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "archive_card",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t<li class="navbar-btn"> <a class="btn btn-default ';
 if(parseInt(card.attributes.is_archived) === 0){ ;
__p += 'js-archive-card';
 }else if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: 'send_back_to_archived_card', board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += ' js-card-send-to-board';
 } ;
__p += ' even-action" title="';
 if(parseInt(card.attributes.is_archived) === 0){;
__p +=
__e( i18next.t('Archive') );
 }else if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: 'send_back_to_archived_card',board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p +=
__e( i18next.t('Send to board') );
};
__p += '" href=""><i class="icon-cloud-download"></i>\n\t\t\t\t\t\t';
 if(parseInt(card.attributes.is_archived) === 0){ ;
__p += '\n\t\t\t\t\t\t\t' +
__e( i18next.t('Archive') ) +
'\n\t\t\t\t\t\t';
 }else if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: 'send_back_to_archived_card',board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t\t  ' +
__e( i18next.t('Send to board') ) +
'\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t</a> \n\t\t\t\t\t\t</li>\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "edit_card",board_user_role_id: parseInt(list.board_user_role_id)})))){ ;
__p += '\n\t\t\t\t\t<li class="dropdown navbar-btn"> <a class="btn btn-default dropdown-toggle js-show-card-due-date-form even-action" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Due Date') ) +
'" href="#"><i class="icon-calendar"></i>' +
__e( i18next.t('Due Date') ) +
'</a>\n\t\t\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12">\n\t\t\t\t\t\t<li class="col-xs-12 clearfix text-center"> <div><span class="col-xs-10"><strong>' +
__e( i18next.t('Due Date') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div> </li>\n\t\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t<li class="js-show-card-due-date-form-response col-xs-12"> </li>\n\t\t\t\t\t  </ul>\n\t\t\t\t\t</li>\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "add_checklists",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t<li class="dropdown navbar-btn"> <a class="btn btn-default dropdown-toggle js-show-checklist-add-form even-action" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Checklist') ) +
'" href="#"><i class="icon-list-ul"></i>' +
__e( i18next.t('Checklist') ) +
'</a>\n\t\t\t\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12">\n\t\t\t\t\t\t\t<li class="col-xs-12 clearfix text-center"> <div><span class="col-xs-10"><strong>' +
__e( i18next.t('Add Checklist') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div> </li>\n\t\t\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t\t<li class="col-xs-12 js-checklist-add-form-response"> </li>\n\t\t\t\t\t\t  </ul>\n\t\t\t\t\t\t</li>\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t </ul>\n\t\t\t\t</div>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t  </li>\n\t\t\t</ul>\n\t\t</div>\n\t  </div>\n\t  <div class="splitter-wrap ui-resizable"> \n\t  <div class="inner col-xs-12">   \n\t\t<ul class="list-unstyled navbar-btn row"  id="card_activities">\n\t\t  <li class="list-group-item list-group-item-info clearfix">\n\t\t\t<div class="list-group-item-heading clearfix">\n\t\t\t\t  <h3 class="pull-left">' +
__e( i18next.t('Activity') ) +
'</h3>\n\t\t\t\t  <div class="clearfix pull-right well-sm user-filter">\n                        <ul class="nav nav-pills">\n                            <li id="modal-activities"><a href="#" title="' +
__e( i18next.t('Filter by activities') ) +
'" class="text-muted" ><i class="icon-time small"></i></a></li>\n                            <li id="modal-comments"><a href="#" title="' +
__e( i18next.t('Filter by comments') ) +
'" class="text-muted"><i class="icon-comment-alt small"></i></a></li>\n                        </ul>      \n                  </div>   \n\t\t\t</div>\n\t\t\t<div class="list-group-item-text">\n\t\t\t  <ul class="media-list">\n\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || ((!_.isEmpty(card.list.collection.board.acl_links.where({slug: "comment_card",board_user_role_id: parseInt(list.board_user_role_id)}))) || (!_.isEmpty(role_links.where({slug: "comment_card"})) && card.list.collection.board.attributes.board_visibility == 2)))){ ;
__p += '\n\t\t\t\t<li class="media comment-block"> \n\t\t\t\t  <form method="post" class="form-horizontal js-add-comment">\n\t\t\t\t  <ul class="media-list">\n\t\t\t\t\t\t<li class="media">\n\t\t\t\t\t\t<a data-placement="bottom" data-container="body" title="' +
__e(authuser.user.full_name ) +
' (' +
__e( authuser.user.username ) +
')" data-toggle="tooltip" class="pull-left" href="#/user/' +
__e( authuser.id ) +
'">\n\t\t\t\t  ';
 if(!_.isEmpty(authuser.user.profile_picture_path)) { 
					var profile_picture_path = card.showImage('User', authuser.user.id, 'small_thumb' );
				  ;
__p += '\n\t\t\t\t  <img src="' +
((__t = (profile_picture_path )) == null ? '' : __t) +
'" alt="[Image: ' +
__e(authuser.user.username ) +
']" class="img-rounded img-responsive avatar">\n\t\t\t\t  ';
 } else {;
__p += '\n\t\t\t\t  <i class="avatar avatar-color-194 img-rounded">' +
__e( authuser.user.initials ) +
'</i>\n\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t  </a>\n\t\t\t\t\t<div class="media-body">\n\t\t\t\t\t  <div class="media-heading clearfix">\n\t\t\t\t\t\t<div class="form-group list-group-item-text">\n\t\t\t\t\t\t\t<div class="col-xs-12 list-group-item-text navbar-right">\n\t\t\t\t\t\t\t\t<label class="sr-only">' +
__e( i18next.t('Comment') ) +
'</label>\n\t\t\t\t\t\t\t\t<textarea id="inputAddComment" class="form-control input-sm js-comment" rows="4" name="comment" placeHolder="' +
__e( i18next.t('Write a comment') ) +
'" required title="' +
__e( i18next.t('Write a comment') ) +
'"></textarea>\t\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t</div>\n\t\t\t\t\t</li>\n\t\t\t\t\t<li class="js-new-comment hide clearfix btn-block navbar-btn">\n\t\t\t\t\t<div class="col-xs-11 radio pull-right btn-block">\n\t\t\t\t\t\t<ul class="list-unstyled clearfix col-xs-12">\n\t\t\t\t\t\t\t<li class="pull-left radio-inline">\n\t\t\t\t\t\t\t\t<div class="clearfix dropdown js-show-emoji-list-response"> <a class="js-show-emoji-list show dropdown-toggle btn-link btn-xs btn-block" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Add Emoji') ) +
'" href="#"> <span class="text-muted show" >' +
__e( i18next.t('Add Emoji') ) +
'</span> </a>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "view_card_search", board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t\t\t<li class="pull-left radio radio-inline">\n\t\t\t\t\t\t\t\t  <div class="clearfix dropdown"> <a class="show dropdown-toggle btn-link btn-xs btn-block" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Add Card') ) +
'" href="#"> <span class="text-muted show" >' +
__e( i18next.t('Add Card') ) +
'</span> </a>\n\t\t\t\t\t\t\t\t\t<ul class="dropdown-menu arrow col-xs-3 list-group">\n\t\t\t\t\t\t\t\t\t  <li class="col-xs-12 clearfix text-center">\n\t\t\t\t\t\t\t\t\t\t<div><span class="col-xs-10"><strong>' +
__e( i18next.t('Add Card') ) +
'</strong></span>\n\t\t\t\t\t\t\t\t\t\t<a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div>\n\t\t\t\t\t\t\t\t\t  </li>\n\t\t\t\t\t\t\t\t\t  <li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t\t\t\t  <li class="col-xs-12 js_activity_card_search_response">\n\t\t\t\t\t\t\t\t\t\t  <div class="clearfix">\n\t\t\t\t\t\t\t\t\t\t\t<label class="sr-only">' +
__e( i18next.t('Search Card') ) +
'</label>                            \n\t\t\t\t\t\t\t\t\t\t\t  <input type="text" placeholder="' +
__e( i18next.t('Search Card') ) +
'" name="card" class="js-search-card form-control input-sm  js-no-action" title="' +
__e( i18next.t('Search Card') ) +
'">\n\t\t\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t\t  </li>\n\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t<li class="dropdown pull-left radio-inline radio">\n\t\t\t\t\t\t\t  <div class="clearfix dropdown"> <a class="show dropdown-toggle btn-link btn-xs btn-block js-show-members" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Mention a member') ) +
'" href="#"> <span class="text-muted show" >' +
__e( i18next.t('Mention a member') ) +
'</span> </a>\n\t\t\t\t\t\t\t\t<ul class="dropdown-menu arrow col-xs-3">\n\t\t\t\t\t\t\t\t  <li class="col-xs-12 clearfix text-center"><div><span class="col-xs-10"><strong>' +
__e( i18next.t('Mention a member') ) +
'</strong></span> <a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div></li>\n\t\t\t\t\t\t\t\t  <li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t\t\t  <li class="col-xs-12 js-comment-member-search-response">\n\t\t\t\t\t\t\t\t\t  <div class="clearfix">\n\t\t\t\t\t\t\t\t\t\t<label class="sr-only">' +
__e( i18next.t('Search Member') ) +
'</label>\n\t\t\t\t\t\t\t\t\t\t<input type="text" autocomplete="off" placeholder="' +
__e( i18next.t('Search Members') ) +
'" name="member" class="js-search-member form-control input-sm js-no-action" title="' +
__e( i18next.t('Search Members') ) +
'">\n\t\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t  </li>\n\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t   </div>\n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t    </ul>\n\t\t\t\t\t<div class="pull-left col-xs-12">\n\t\t\t\t\t  <label class="sr-only" for="submit2">' +
__e( i18next.t('Submit') ) +
'</label>\n\t\t\t\t\t  <div class="radio-inline">\n\t\t\t\t\t\t  <input type="submit" id="submitCommentAdd" class="btn btn-primary" value="' +
__e( i18next.t('Comment') ) +
'"/>\n\t\t\t\t\t  </div>\n\t\t\t\t\t</div>\n\t\t\t\t  </div>\n\t\t\t\t  </li>\n\t\t\t\t  </ul>\n\t\t\t\t </form>\n\t\t\t\t  \n\t\t\t\t</li>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t<li> </li>\n\t\t\t\t<li class="col-xs-12 divider"><hr></li>\n\t\t\t  </ul>\n\t\t\t  <div class="text-center clearfix hide" id="js-loader-img"><img src="img/select2-spinner.gif" alt="[Images:Loader]" title="' +
__e( i18next.t('Loading...') ) +
'" /></div>\n\t\t\t\t<ul class="media-list col-xs-12 clearfix btn-block" id="js-card-activities-' +
((__t = ( card.attributes.id)) == null ? '' : __t) +
'"></ul>\t\t\t  \n\t\t\t</div>\n\t\t\t</li>\n\t\t  </ul>\n\t\t</div>\n\t  </div>\n  </div>\n  <div class="drag-drop">' +
__e( i18next.t('Drop Files Here') ) +
'</div>\n    \n  </div>\n  <!-- Side Menu block start -->\n  ';
if(!_.isUndefined(authuser.user)) {;
__p += '\n  <div class="dropdown dockheader-dropdown docmodal-submenu">\n  <a aria-expanded="true" data-toggle="dropdown" id="dropdownMenu1" class="dropdown-toggle label"> <i class="icon-cog h3"></i></a>\n  <ul role="menu" class="dropdown-menu arrow">\n\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "edit_card",board_user_role_id: parseInt(list.board_user_role_id)})))){ ;
__p += '\n\t  <li class="dropdown-submenu dropdown"> \n\t\t<a href="#" title="' +
__e( i18next.t('Add') ) +
'" class="dropdown-toggle js-open-popover" data-toggle="dropdown" >' +
__e( i18next.t('Add') ) +
'</a>\n\t\t<ul class="dropdown-menu">\n\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "edit_card",board_user_role_id: parseInt(list.board_user_role_id)})))){ ;
__p += '\n\t\t<li class="dropdown"> <a class="dropdown-toggle js-show-card-due-date-form" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Due Date') ) +
'" href="#">' +
__e( i18next.t('Due Date') ) +
'</a>\n\t\t  <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12">\n\t\t\t<li class="col-xs-12 clearfix text-center"> <div><span class="col-xs-10"><strong>' +
__e( i18next.t('Due Date') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div> </li>\n\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t<li class="js-show-card-due-date-form-response col-xs-12"> </li>\n\t\t  </ul>\n\t\t</li>\n\t\t';
 } ;
__p += '\n\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "add_card_user",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t<li class="dropdown"><a data-toggle="dropdown" class="dropdown-toggle js-show-add-member-form js-card-header-action" title="' +
__e( i18next.t('Members') ) +
'" href="#">' +
__e( i18next.t('Members') ) +
'</a>\n\t\t\t\t  <ul class="dropdown-menu arrow">\n\t\t\t\t\t<li class="col-xs-12 text-center clearfix">\n\t\t\t\t\t  <div><span class="col-xs-10"><strong>' +
__e( i18next.t('Members') ) +
'</strong></span> <a href="#" class="js-close-popover pull-right"><i class="icon-remove"></i></a></div>\n\t\t\t\t\t</li>\n\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t  <form method="post" class="text-center" name="addMember">\n\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t  <label class="sr-only">' +
__e( i18next.t('Search Member') ) +
'</label>\n\t\t\t\t\t\t  <input type="text" autocomplete="off" id="inputOrganizationUserSearch" placeholder="' +
__e( i18next.t('Search Members') ) +
'" name="email" required class="js-search-users form-control input-sm" title="' +
__e( i18next.t('Search Members') ) +
'">\n\t\t\t\t\t\t</div>\n\t\t\t\t\t  </form>\n\t\t\t\t\t</li>\n\t\t\t\t\t<li class="clearfix js-organization-member-search-response col-xs-12 small">' +
__e( i18next.t('Search for a person in %s by name or email address.', { postProcess: 'sprintf', sprintf: [SITE_NAME] }) ) +
'</li>\n\t\t\t\t  </ul>\n\t\t\t</li>\n\t\t';
 } ;
__p += '\n\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "delete_labels",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t<li class="dropdown"> <a class="dropdown-toggle js-show-card-label-form js-card-header-action" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Labels') ) +
'" href="#">' +
__e( i18next.t('Labels') ) +
'</a>\n\t\t\t\t<ul class="dropdown-menu dropdown-menu-left arrow col-xs-12 js-show-card-label-form-response">\n\t\t\t\t</ul>\n\t\t\t</li>\n\t\t';
 } ;
__p += '\n\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "add_checklists",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t    <li class="dropdown"> <a class="dropdown-toggle js-show-checklist-add-form" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Checklist') ) +
'" href="#">' +
__e( i18next.t('Checklist') ) +
'</a>\n\t\t      <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12">\n\t\t\t\t<li class="col-xs-12 clearfix text-center"> <div><span class="col-xs-10"><strong>' +
__e( i18next.t('Add Checklist') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div> </li>\n\t\t        <li class="col-xs-12 divider"></li>\n\t\t\t\t<li class="col-xs-12 js-checklist-add-form-response"> </li>\n\t\t      </ul>\n\t\t    </li>\n\t    ';
 } ;
__p += '\n\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "edit_card",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t<li class="dropdown"> <a class="js-show-side-card-title-edit-form" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Checklist') ) +
'" href="#">' +
__e( i18next.t('Info') ) +
'</a>\n\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12">\n\t\t\t\t<li class="col-xs-12 clearfix text-center"> <div><span class="col-xs-10"><strong>' +
__e( i18next.t('Edit Card Info') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div> </li>\n\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t<li class="col-xs-12 js-show-side-card-title-edit-form-response">\n\t\t\t\t  <form class="js-card-edit-form" method="POST">\n\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t  <label for="cardTitle' +
__e( card.id) +
'">' +
__e( i18next.t('Title') ) +
'</label>\n\t\t\t\t\t  <input type="text" class="form-control" id="cardTitle' +
__e( card.id) +
'" name="name" data-format="hh:mm:ss" value="' +
__e( card.attributes.name ) +
'"/>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t  <label for="cardDescription' +
__e( card.id) +
'">' +
__e( i18next.t('Description') ) +
'</label>\n\t\t\t\t\t  <textarea name="description" rows="3" class="form-control" id="cardDescription' +
__e( card.id) +
'">' +
__e( card.attributes.description ) +
'</textarea>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t  <div class="col-xs-6 nav">\n\t\t\t\t\t\t<label for="save" class="sr-only">' +
__e( i18next.t('Save') ) +
'</label>\n\t\t\t\t\t\t<input type="submit" value="' +
__e( i18next.t('Save') ) +
'" id="save" class="btn btn-primary" id="submitCardInfoEditForm">\n\t\t\t\t\t  </div>\n\t\t\t\t\t</div>\n\t\t\t\t  </form>\n\t\t\t\t</li>\n\t\t\t  </ul>\n\t\t\t</li>\n\t\t\t';
 } ;
__p += '\n\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "add_card_attachment",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t<li class="dropdown"> <a class="dropdown-toggle js-load-dropbox js-card-header-action" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Attachment') ) +
'" href="#">' +
__e( i18next.t('Attachment') ) +
'</a>\n\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12">\n\t\t\t   <li class="col-xs-12 clearfix text-center"> <div><span class="col-xs-10"><strong>' +
__e( i18next.t('Attach From...') ) +
' </strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div> </li>\n\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t<li class="col-xs-12"><a href="#" title="' +
__e( i18next.t('Computer') ) +
'" class="js-attachment-computer-open row">' +
__e( i18next.t('Computer') ) +
'</a></li>\n\t\t\t\t<li class="col-xs-12"><a href="#" title="' +
__e( i18next.t('Dropbox') ) +
'" class="js-attachment-dropbox-open row">' +
__e( i18next.t('Dropbox') ) +
'</a></li>\n\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t<li class="col-xs-12">\n\t\t\t\t  <span class="col-xs-10 sr-only">' +
__e( i18next.t('Attach a Link') ) +
'</span>\n\t\t\t\t  <form class="js-card-attachment-link-form col-xs-12" method="post" role="form">\n\t\t\t\t\t<div class="form-group row">\n\t\t\t\t\t  <input type="url" class="form-control input-sm"   id="" name="image_link" placeHolder="' +
__e( i18next.t('Paste any link here') ) +
'" title="' +
__e( i18next.t('Whitespace alone not allowed') ) +
'" required pattern=".*\\S+.*">\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="form-group row">    \n\t\t\t\t\t  <input type="submit" value="' +
__e( i18next.t('Submit') ) +
'" id="submit2" class="btn btn-primary btn-sm">\n\t\t\t\t\t</div>\n\t\t\t\t\t<span class="help-block row small">' +
__e( i18next.t('Tip: You can drag and drop files and links onto cards to upload them.') ) +
'</span>\n\t\t\t\t  </form>\n\t\t\t\t</li>\n\t\t\t  </ul>\n\t\t\t</li>\n\t\t\t';
 } ;
__p += '\n\t\t</ul>\n\t  </li>\n\t  ';
 } ;
__p += '\n\t  ';
 if(!_.isUndefined(authuser.user)) { ;
__p += '\n\t  <li class="dropdown-submenu dropdown"> <a href="#" title="' +
__e( i18next.t('Actions') ) +
'" class="dropdown-toggle js-open-popover" data-toggle="dropdown">' +
__e( i18next.t('Actions') ) +
'</a>\n\t\t  <ul class="dropdown-menu">\n\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "move_list_cards",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t<li class="dropdown"> <a class="dropdown-toggle js-show-move-card-form js-card-header-action" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Move') ) +
'" href="#">' +
__e( i18next.t('Move') ) +
'</a>\n\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12">\n\t\t\t\t<li class="col-xs-12 clearfix text-center"><div> <span class="col-xs-10"><strong>' +
__e( i18next.t('Move Card') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div></li>\n\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t<li class="col-xs-12">\n\t\t\t\t  <form role="form" class="js-move-card" name="MoveCardForm" id="MoveCardForm">\n\t\t\t\t\t<div class="js-show-move-card-form-response"> </div>\n\t\t\t\t\t<div class="form-group clearfix panel-body">\n\t\t\t\t\t  <label class="sr-only">' +
__e( i18next.t('Move') ) +
'</label>\n\t\t\t\t\t  <input type="submit" id="submitListMove" class="btn btn-primary col-xs-12" value="' +
__e( i18next.t('Move') ) +
'" />\n\t\t\t\t\t</div>\n\t\t\t\t  </form>\n\t\t\t\t</li>\n\t\t\t  </ul>\n\t\t\t</li>\n\t\t\t';
 } ;
__p += '\n\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(card.list.collection.board.acl_links.where({slug: "copy_card",board_user_role_id: parseInt(list.board_user_role_id)})))  && !is_offline_data){ ;
__p += '\n\t\t\t\t<li class="dropdown js-hide-on-offline"> <a class="dropdown-toggle js-show-copy-card-form" role="button" data-toggle="dropdown" title="' +
__e( i18next.t('Copy') ) +
'" href="#">' +
__e( i18next.t('Copy') ) +
'</a>\n\t\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow col-xs-12 pre-scrollable vertical-scrollbar">\n\t\t\t\t\t<li class="col-xs-12 clearfix text-center"> <div><span class="col-xs-10"><strong>' +
__e( i18next.t('Copy Card') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div> </li>\n\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t  <form role="form" method="post" class="js-copy-card">\n\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t  <label for="card-title">' +
__e( i18next.t('Title') ) +
'</label>\n\t\t\t\t\t\t  <textarea id="card-title" class="form-control" rows="4" name="name">' +
__e( card.attributes.name) +
'</textarea>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<div class="js-show-copy-card-form-response"> </div>\n\t\t\t\t\t\t<div class="form-group clearfix panel-body">\n\t\t\t\t\t\t  <label class="sr-only">' +
__e( i18next.t('Create card') ) +
'</label>\n\t\t\t\t\t\t  <input type="submit" class="btn btn-primary col-xs-12" value="' +
__e( i18next.t('Create card') ) +
'">\n\t\t\t\t\t\t</div>\n\t\t\t\t\t  </form>\n\t\t\t\t\t</li>\n\t\t\t\t  </ul>\n\t\t\t\t</li>\n\t\t\t';
 } ;
__p += '\n\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || (((!_.isEmpty(card.list.collection.board.acl_links.where({slug: "subscribe_card",board_user_role_id: parseInt(list.board_user_role_id)})) && _.isEmpty(cards_subscribers)) || (!_.isEmpty(card.list.collection.board.acl_links.where({slug: "unsubscribe_card",board_user_role_id: parseInt(list.board_user_role_id)})) && !_.isEmpty(cards_subscribers)))  || (!_.isEmpty(role_links.where({slug: "subscribe_card"})) && card.list.collection.board.attributes.board_visibility == 2)))) { ;
__p += '\n\t\t\t\t';

					var subscribe_disabled = '';
					var subscribed = card.list.collection.board.board_subscribers.findWhere({
						user_id: parseInt(authuser.user.id),
						is_subscribed: 1
					}); 
					if (subscribed) {
						subscribe_disabled = 'disabled';
						subscribe_title = i18next.t('Board wise subscription already enabled');
					}
				;
__p += '\n\t\t\t    <li class="' +
((__t = ( subscribe_disabled )) == null ? '' : __t) +
'"> <a class="';
 if(!_.isEmpty(cards_subscribers)){;
__p += ' js-card-unsubscribe ';
 } else {;
__p += 'js-card-subscribe ';
 };
__p += '" title="' +
__e( subscribe_title ) +
' " href="">' +
__e( i18next.t('Subscribe') ) +
'\n\t\t       ';
 if(!_.isEmpty(cards_subscribers)){ ;
__p += '\n\t\t\t    <i class="icon-ok"></i>\n\t\t      ';
 } ;
__p += '\n\t\t      </a> \n\t\t\t  </li>\n\t\t   ';
 } ;
__p += '\n\t\t   ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "vote_card",board_user_role_id: parseInt(list.board_user_role_id)})) || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "unvote_card",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t    <li>\n\t\t      ';
 if(!_.isUndefined(authuser) && !_.isUndefined(authuser.user)){
					var voted_user = card.card_voters.findWhere({
					 user_id: parseInt(authuser.user.id)
					}); 
				
			;
__p += '\n\t\t      ';
 if(_.isEmpty(voted_user)){  ;
__p += '\n\t\t      ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "vote_card",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t      <a class="panel-heading show js-add-card-vote" title="' +
__e( i18next.t('Vote') ) +
'" href="#">' +
__e( i18next.t('Vote') ) +
'</a>\n\t\t\t  ';
 } ;
__p += '\n\t\t\t  ';
 } else{ ;
__p += ' \n\t\t\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "unvote_card",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t  <a class="panel-heading show js-delete-card-vote"" title="' +
__e( i18next.t('Unvote') ) +
'" href="#" data-id="' +
__e( voted_user.id ) +
'"> <span class="show" ><i class="icon-thumbs-up-alt"></i>' +
__e( i18next.t('Unvote') ) +
'</span> </a>\n\t\t\t  ';
 } ;
__p += '\n\t\t\t  ';
 } };
__p += '\n\t\t\t</li>\n\t\t ';
 } ;
__p += '\n\t\t ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "archive_card",board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t<li> <a class="panel-heading show ';
 if(parseInt(card.attributes.is_archived) === 0){ ;
__p += 'js-archive-card';
 }else if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: 'send_back_to_archived_card', board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += ' js-card-send-to-board';
 } ;
__p += '" title="';
 if(parseInt(card.attributes.is_archived) === 0){;
__p +=
__e( i18next.t('Archive') );
 }else if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: 'send_back_to_archived_card',board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p +=
__e( i18next.t('Send to board') );
};
__p += '" href="">\n\t\t      ';
 if(parseInt(card.attributes.is_archived) === 0){ ;
__p += '\n\t\t\t      ' +
__e( i18next.t('Archive') ) +
'\n\t\t      ';
 }else if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: 'send_back_to_archived_card',board_user_role_id: parseInt(list.board_user_role_id)})))) { ;
__p += '\n\t\t\t\t  ' +
__e( i18next.t('Send to board') ) +
'\n\t\t      ';
 } ;
__p += '\n\t\t\t\t</a> \n\t\t\t</li>\n\t\t\t';
 } ;
__p += '\n\t\t    ';
 if(parseInt(card.attributes.is_archived) === 1 && (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({slug: "delete_card",board_user_role_id: parseInt(list.board_user_role_id)}))))){ ;
__p += '\n\t\t\t<li >\n\t\t\t  <ul class="list-unstyled panel-body">\n\t\t\t\t<li class="dropdown"> <a class="col-xs-12 btn btn-primary whitec dropdown-toggle js-open-dropdown" href="#" data-toggle="dropdown"> <span><i class="icon-archive"></i></span> <span>' +
__e( i18next.t('Delete') ) +
'</span> </a>\n\t\t\t\t  <ul class="dropdown-menu dropdown-menu-left arrow">\n\t\t\t\t\t<li class="js-dropdown-popup dropdown-popup">\n\t\t\t\t\t  <div class="clearfix text-center col-xs-12"> <span class="col-xs-10"><strong>' +
__e( i18next.t('Delete Card') ) +
'?</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a> </div>\n\t\t\t\t\t  <div class="col-xs-12 divider"></div>\n\t\t\t\t\t  <div class="col-xs-12">\n\t\t\t\t\t\t<p>' +
__e( i18next.t("All actions will be removed from the activity feed and you won't be able to reopen the card. There is no undo. You can archive a card to remove it from the board and preserve the activity.") ) +
'</p>\n\t\t\t\t\t\t<a class="js-delete-card btn  btn-primary" title="' +
__e( i18next.t('Delete') ) +
'">' +
__e( i18next.t('Delete') ) +
'</a> </div>\n\t\t\t\t\t</li>\n\t\t\t\t  </ul>\n\t\t\t\t</li>\n\t\t\t  </ul>\n\t\t\t</li>\n\t\t\t';
 } ;
__p += '\n\t\t  </ul>\n\t  </li>\n\t  ';
 } ;
__p += '\n\t  <li class="dropdown js-more-dropdown">\n\t  <div class="col-xs-12 divider"></div>\n\t  <a class="show btn btn-link js-more-menu quiet-button" data-toggle="dropdown" title="' +
__e( i18next.t('More options share, print, export, and delete.') ) +
'" href="#">' +
__e( i18next.t('Share and more...') ) +
'</a>\n\t\t<ul class="dropdown-menu dropdown-menu-left arrow col-xs-12">\n\t\t\t<li class="col-xs-12 clearfix text-center"><div> <span class="col-xs-10"><strong>' +
__e( i18next.t('More') ) +
'</strong></span> <a class="js-close-popover pull-right" href="#"><i class="icon-remove "></i></a></div></li>\n\t\t\t<li class="col-xs-12 divider"></li>       \n\t\t\t<li class="col-xs-12">\n\t\t\t  <p class="text-muted"> <span class="show">' +
__e( i18next.t('Card # %s', { postProcess: 'sprintf', sprintf: [card.attributes.id] }) ) +
'</span> <span class="show">' +
__e( i18next.t('Link to this card') ) +
'</span> </p>\n\t\t\t  <form role="form">\n\t\t\t\t<div class="form-group">\n\t\t\t\t  <input type="text" value="' +
((__t = ( window.location.origin )) == null ? '' : __t) +
'' +
((__t = ( window.location.pathname )) == null ? '' : __t) +
'#/board/' +
__e( card.attributes.board_id ) +
'/card/' +
__e( card.attributes.id ) +
'" class="form-control input-sm js-select-card-url" readonly="readonly">\n\t\t\t\t</div>\n\t\t\t\t';
 if(!_.isEmpty(IMAP_EMAIL)){ ;
__p += '\n\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t';
 var imap_email = IMAP_EMAIL.split('@');
						   var card_email = imap_email[0] + '+' + card.attributes.board_id + '+' + card.attributes.id + '+' + calcMD5(SecuritySalt + card.attributes.board_id + card.attributes.id)+'@'+imap_email[1];
						;
__p += '\n\t\t\t\t\t  <span class="show">' +
__e( i18next.t("Email for this card") ) +
'</span>\n\t\t\t\t\t  <input readonly="readonly" class="form-control" value="' +
__e( card_email ) +
'">\n\t\t\t\t\t</div>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t  </form>\n\t\t\t</li>\n\t\t </ul>\n\t  </li>\n  </ul>\n  </div>\n  ';
};
__p += '\n  <!-- Side Menu block end -->\n</section>\n';

}
return __p
};

this["JST"]["templates/modal_chat_history_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="modal fade modalChatHistoryView" id="modalChatHistoryView" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">\n\t<div class="modal-dialog">\n\t\t  <div class="modal-content">\n\t\t\t<div class="modal-header">\n\t\t\t<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>\n\t\t\t<h4 id="myModalLabel" class="modal-title"><strong>Chat History</strong></h4>\n\t\t\t</div>\t\t\t\n\t\t\t<div class="modal-body scrollbar">\n\t\t\t\t<div>\n\t\t\t\t\t<div class="clearfix">\n\t\t\t\t\t\t<ul class="clearfix list-unstyled" id="js-chat-history-list"></ul>\n\t\t\t\t\t\t<span class="btn btn-primary" id="js-chat-histories-load-more" data-page="1">Load more histories</span>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t  </div><!-- /.modal-content -->\n    </div>\n</div>';

}
return __p
};

this["JST"]["templates/modal_flickr_photo_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="modal fade" id="modalFlickrPhoto" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">\n\t<div class="modal-dialog">\n\t\t  <div class="modal-content">\n\t\t\t<div class="modal-header">\n\t\t\t  <button type="button" class="close js-close-popover" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>\n\t\t\t  <h4 id="myModalLabel" class="modal-title"><strong>' +
__e( i18next.t('Background Photo') ) +
'</strong></h4>\n\t\t\t</div>\t\t\t\n\t\t\t<div class="modal-body clearfix">\t\n\t\t\t\t<div class="navbar-btn col-xs-4 nav">\n\t\t\t\t\t<div class="input-group">\n\t\t\t\t\t\t<input type="text" class="form-control input-sm js-flickr-search" placeholder="' +
__e( i18next.t('Search') ) +
'" title="' +
__e( i18next.t('Search') ) +
'">\n\t\t\t\t\t\t<span class="input-group-btn"><button class="btn btn-primary input-sm btn-sm js-flickr-search-box" type="button"><i class="icon-search cur"></i></button></span>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="pull-right h4"><small class="navbar-btn">' +
__e( i18next.t('Powered by') ) +
' <a href="javascript:void(0);" title="Flickr"><strong class="text-primary">Flickr</strong></a></small></div>\n\t\t\t\t<div class="col-xs-12 h4">\n\t\t\t\t<ul class="list-inline clearfix col-xs-offset-0" id="js-flickr-background-photos">\n\t\t\t\t \n\t\t\t\t</ul>\n\t\t\t\t</div>\n\t\t\t\t<div class="h4 btn-block pull-left text-center js-flickr-loader-and-more"><a href="javascript:void(0);" class="btn-link js-flickr-loadmore">' +
__e( i18next.t('Load More') ) +
'</a></div>\t\t\t\t\t\t\t\t\t\t\t\n\t\t\t</div>\n\t\t  </div><!-- /.modal-content -->\n    </div>\n</div>';

}
return __p
};

this["JST"]["templates/modal_list_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="modal fade" id="modalListView" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">\n\t<div class="modal-dialog modal-lg">\n\t\t  <div class="modal-content">\n\t\t\t<div class="modal-header">\n\t\t\t  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>\n\t\t\t  <a href="#" title="' +
__e( list.attributes.name ) +
'" class="">\n\t\t\t  <h4 id="myModalLabel" class="modal-title htruncate"><strong>' +
__e( list.attributes.name ) +
'</strong></h4></a>\n\t\t\t</div>\t\t\t\n\t\t\t<div class="modal-body clearfix">\t\n\t\t\t\t<ul class="list-unstyled clearfix col-xs-12 btn-block" id="js-list-attachments-list"><li><span class="cssloader"></span></li></ul>\t\t\t\t\t\t\t\t\t\t\t\n\t\t\t</div>\n\t\t  </div><!-- /.modal-content -->\n    </div>\n</div>';

}
return __p
};

this["JST"]["templates/modal_music_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="modal fade" id="modalMusic" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">\n\t<div class="modal-dialog">\n\t\t  <div class="modal-content">\n\t\t\t<div class="modal-header">\n\t\t\t  <button type="button" class="close js-close-popover" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>\n\t\t\t  <h4 id="myModalLabel" class="modal-title"><strong>' +
__e( i18next.t('Productivity Beats') ) +
'</strong></h4>\n\t\t\t</div>\t\t\t\n\t\t\t<div class="modal-body clearfix">\t\t\t\t\t\n\t\t\t\t<div class="col-xs-12 h4 btn-block">\n\t\t\t\t\t<form class="form-horizontal" name="musicUpdate" id="js-MusicForm">\t\t\t\t\t\t\n\t\t\t\t\t  <div class="form-group input text required">\n\t\t\t\t\t\t<label for="title" class="sr-only">' +
__e( i18next.t('Name') ) +
'</label>\n\t\t\t\t\t\t<div class="col-xs-12">\n\t\t\t\t\t\t  <input type="text" class="form-control js-music_name" id="title" placeholder="' +
__e( i18next.t('Name') ) +
'" required title="' +
__e( i18next.t('Name') ) +
'">\n\t\t\t\t\t\t</div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t  <div class="form-group required">\n\t\t\t\t\t\t<label class="sr-only">' +
__e( i18next.t('abc Notation') ) +
'</label>\n\t\t\t\t\t\t<div class="col-xs-12">\n\t\t\t\t\t\t  <textarea class="form-control js-music_content" rows="3" placeholder="' +
__e( i18next.t('abc Notation') ) +
'" required></textarea>\n\t\t\t\t\t\t  <div>\n\t\t\t\t\t\t\t<span class="help-block">\n\t\t\t\t\t\t\t\t' +
__e( i18next.t('Enter abc music notation. May choose from') ) +
' <a href="http://reissendewoelfe.de/abc/" target="_blank">Reissende Woelfe Collections</a>, <a href="http://abcnotation.com/" target="_blank">abcnotation</a>, or <a href="http://www.lotro-abc.com/" target="_blank">Lotro ABC</a>\n\t\t\t\t\t\t\t</span>\n\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t<label for="submit2" class="col-sm-1 control-label sr-only">' +
__e( i18next.t('Submit') ) +
'</label>\n\t\t\t\t\t\t\t<input type="submit" value="' +
__e( i18next.t('Submit') ) +
'" id="js-music_add" class="btn btn-primary btn-lg">\n\t\t\t\t\t\t</div>\t\t\t\t\t  \n\t\t\t\t\t</form>\t\t\t\t\n\t\t\t\t</div>\t\t\t\t\t\t\t\t\t\t\n\t\t\t</div>\n\t\t  </div><!-- /.modal-content -->\n    </div>\n</div>';

}
return __p
};

this["JST"]["templates/modal_shortcut"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="modal fade" id="ModalShortcutView" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">\n\t<div class="modal-dialog modal-lg">\n\t\t  <div class="modal-content">\n\t\t\t<div class="modal-header">\n\t\t\t  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>\n\t\t\t  <a href="#" title="' +
__e( i18next.t("Keyboard Shortcuts") ) +
'" class="">\n\t\t\t  <h2 id="myModalLabel" class="modal-title htruncate"><strong>' +
__e( i18next.t("Keyboard Shortcuts") ) +
'</strong></h2></a>\n\t\t\t</div>\t\t\t\n\t\t\t<div class="modal-body clearfix">\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Add / Remove Members") ) +
'</span>\t\t\t\t\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">M</span>\n\t\t\t\t</div>\t\t\t\t\n\t\t\t\t<p>' +
__e( i18next.t('"m" opens the add / remove members menu. Clicking a member avatar will assign or unassign that person.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Archive Card") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">C</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('"c" will archive a card.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Assign Self") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">space</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('"space" will assign (or unassign) yourself to a card.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Clear All Filters") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">X</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('Use "x" to clear all active card filters.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Due Date") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">D</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('"d" will open the due date picker for a card.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Edit Title") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">T</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('If viewing a card, "t" will edit the title. If hovering over a card, "t" will open the card and edit the title.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Insert New Card") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">N</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('"n" opens a pop-over that allows you to add a card after the currently selected card.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Label") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">L</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('"l" opens a pop-over of the available labels. Clicking a label will add or remove it from the card.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("My Cards Filter") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">Q</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('"q" key toggles the "cards assigned to me" filter.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Navigate Cards") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">&#8592;</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">&#8595;/J</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">&#8593;/K</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">&#8594;</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('Arrow keys will select adjacent cards on a board. "j" will select the card below the current card. "k" will select the card above the current card.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Open Card") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">enter</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('"enter" will open the currently selected card.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Open Card Filter Menu") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">F</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('Use "f" to open the card filter menu.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Open Shortcuts Page") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">?</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('"?" will open the shortcuts page.') ) +
'</p>\t\t\t\t\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Subscribe") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">S</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('"s" will subscribe you to, or unsubscribe you from, a card. Subscribing to a card will give you notifications for most actions to that card.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Toggle Board Menu") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">W</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('"w" will collapse or expand the board menu, the sidebar on the right.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t\t<div class="clearfix">\n\t\t\t\t<span class="h3 pull-left">' +
__e( i18next.t("Vote") ) +
'</span>\n\t\t\t\t<span class="pull-right label label-primary right-mar well-sm">V</span>\n\t\t\t\t</div>\n\t\t\t\t<p>' +
__e( i18next.t('"v" will add (or remove) your vote on a card.') ) +
'</p>\n\t\t\t\t<hr/>\n\t\t\t</div>\n\t\t  </div><!-- /.modal-content -->\n    </div>\n</div>\n\n';

}
return __p
};

this["JST"]["templates/modal_user_activities_list_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="modal fade" id="modalUserActivitiesListView" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">\n\t<div class="modal-dialog">\n\t\t  <div class="modal-content">\n\t\t\t<div class="modal-header">\n\t\t\t  <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">&times;</button>\t\t\t  \n\t\t\t<h4 id="myModalLabel" class="modal-title"><strong>' +
__e( list.attributes.full_name ) +
'</strong> (' +
__e( list.attributes.username ) +
')</h4>\n\t\t\t</div>\t\t\t\n\t\t\t<div class="modal-body scrollbar">\n\t\t\t\t<div>\n\t\t\t\t\t<div class="clearfix">\n\t\t\t\t\t\t<ul class="clearfix list-unstyled" id="js-list-user-activities-list"></ul>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t  </div><!-- /.modal-content -->\n    </div>\n</div>';

}
return __p
};

this["JST"]["templates/move_card"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {


var content_board = '<div class="form-group clearfix"><select name="board_id" class="js-change-list col-xs-12 form-control input-sm cur">';
var content_list = '<div class="form-group clearfix"><select name="list_id" class="js-change-position col-xs-12 form-control input-sm cur">';
var content_position = '<div class="form-group clearfix"><select name="position" class="js-position col-xs-12 form-control input-sm cur">';
card.list.cards.sortByColumn('position');
var current_position = card.list.cards.indexOf(card.list.cards.get(card.attributes.id)) + 1;
if(current_position == 0){
	current_position = 1;
}
boards.each(function(board) {
	if (card.attributes.board_id == board.id) {
		content_board += '<option value="' + board.id + '" selected="selected">' + _.escape(board.attributes.name) +  ' '+i18next.t('(current)')+'</option>';
		//board.lists.add(board.attributes.lists);
		var filtered_lists = board.lists.where({
			is_archived: 0,
			board_id: card.attributes.board_id
		});
		_.each(filtered_lists, function(list) {
		
			if (card.attributes.list_id == list.id) {
				content_list += '<option value="' + list.id + '" selected="selected">' + _.escape(list.attributes.name) +  ' '+ i18next.t('(current)')+'</option>';
				for(var i = 1; i <= list.attributes.card_count; i++){
					if (card.attributes.list_id == list.attributes.id && i == current_position) {
						content_position += '<option value="' + i + '" selected="selected">' + i +  ' '+i18next.t('(current)')+'</option>';
					} else {
						content_position += '<option value="' + i + '">' + i+ '</option>';
					}
				}
				if (card.attributes.list_id != list.attributes.id) {
				    var next_position = parseInt(list.attributes.card_count ) + 1;
					content_position += '<option value="' + next_position + '">' + next_position+ '</option>';
				}
				
			} else {
				content_list += '<option value="' + list.id + '">' + _.escape(list.attributes.name) + '</option>';
			}

		});
	} else {
		if(parseInt(board.attributes.is_closed) === 0){
			content_board += '<option value="' + board.id + '">' + _.escape(board.attributes.name) + '</option>';
		}
	}

});
content_board += '</select></div>';
content_list += '</select></div>';
content_position += '</select></div>';
var content = content_board + content_list + content_position;
;
__p += '\n' +
((__t = ( content )) == null ? '' : __t);

}
return __p
};

this["JST"]["templates/move_cards_from_list"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 
	var list_li = '';
	_.each(filtered_lists, function(filtered_list) {
		 if (filtered_list.id == list.attributes.id) {
			 list_li += '<li class="disabled navbar-btn"><a href="#" class="js-no-action text-muted">' + _.escape(filtered_list.attributes.name) + ' '+i18next.t('(current)')+'</a></li>';
		 } else {
			 list_li += '<li class="navbar-btn"><a href="#" class="js-move-cards js-close-popup" data-move-list-id="' + filtered_list.id + '">' + _.escape(filtered_list.attributes.name) + '</a></li>';
		 }
	 });
;
__p += '\n<li class="clearfix text-center col-xs-12">\n\t<div class="clearfix">\n\t<a href="#" class="js-back-to-list-actions pull-left" data-list-id="' +
__e( list.id) +
'"><i class="icon-caret-left"></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t('Move All Cards in this List') ) +
'</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove"></i></a>\n\t</div>\t\n</li>\n<li class="col-xs-12 divider"></li>\n' +
((__t = ( list_li)) == null ? '' : __t);

}
return __p
};

this["JST"]["templates/move_list"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {


var content_board = '<div class="form-group clearfix col-xs-12"><select name="board_id" class="js-move-change-list col-xs-12 form-control input-sm cur">';
var content_position = '<div class="form-group clearfix col-xs-12"><select name="list_id" id="list_position" class="js-move-change-position col-xs-12 form-control input-sm cur">';
var board_lists = new App.ListCollection();
board_lists.sortByColumn('position');
var current_position = board_lists.indexOf(board_lists.findWhere({id: list.attributes.id})) + 1;
if(current_position == 0){
	current_position = 1;
}
boards.each(function(board) {
	if (list.attributes.board_id == board.id) {
		var list_count = board.lists.where({is_archived: 0}).length;
		content_board += '<option value="' + board.id + '" selected="selected">' + _.escape(board.attributes.name) + ' '+ i18next.t('(current)')+'</option>';  
		 for(var i = 1; i <= list_count; i++) { 
			if (i == list.attributes.position) {  
				content_position += '<option value="' + i + '" selected="selected">' + i + ' '+i18next.t('(current)')+'</option>';
			} else {
				content_position += '<option value="' + i + '">' + i+ '</option>';
			}
		}
		if (list.attributes.board_id != board.attributes.id) {
			var next_position = parseInt(list_count) + 1;
			content_position += '<option value="' + next_position + '">' + next_position+ '</option>';
		}
	} else {
		if (parseInt(board.attributes.is_closed) === 0) {
			content_board += '<option value="' + board.id + '">' + _.escape(board.attributes.name) + '</option>';
		}
	}

});
content_board += '</select></div>';
content_position += '</select></div>';
var content = content_board + content_position;
;
__p += '\n<div class="clearfix text-center col-xs-12"><a data-list-id="268" class="js-back-to-list-actions pull-left" href="#"><i class="icon-caret-left"></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t('Move List') ) +
'</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove"></i></a></div><div class="col-xs-12 divider"></div>\n<form role="form" class="js-move-list" name="MoveListForm" id="MoveListForm">\n' +
((__t = ( content )) == null ? '' : __t) +
'\n  <div class="form-group clearfix panel-body">\n\t<label class="sr-only">' +
__e( i18next.t('Move') ) +
'</label>\n\t<input type="submit" id="submitListMove" class="btn btn-primary col-xs-12" value="' +
__e( i18next.t('Move') ) +
'" />\n  </div>\n</form>';

}
return __p
};

this["JST"]["templates/my_boards_listing"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(board != null){	
	var style = '';	
	board.board_subscribers.add(board.attributes.boards_subscribers);
	var subscriber = board.board_subscribers.findWhere({
	board_id: parseInt(board.id),
	user_id: parseInt(authuser.user.id)
	});
	if (board.attributes.background_picture_url) {
		var background_picture_url = board.attributes.background_picture_url.replace("_XXXX.jpg", "_s.jpg");
		style = 'background-image:url(' + background_picture_url + '); background-size:cover;';
	} else if (board.attributes.background_pattern_url) {
		var background_pattern_url = board.attributes.background_pattern_url.replace("_XXXX.jpg", "_s.jpg");
		style = 'background-image:url(' + background_pattern_url + '); background-size:cover;';
	} else if (board.attributes.background_color){
		style = 'background-color:' + board.attributes.background_color + ';color:#ffffff;';
	}
;
__p += '\n<a  href="#/board/' +
__e( board.attributes.id ) +
'" class="highlight-icon clearfix">\n\t<span style="' +
((__t = ( style )) == null ? '' : __t) +
'" class="preview-thumbnail"></span>\n\t<span class="details navbar-btn">\n\t\t<span title="' +
__e( board.attributes.name ) +
'" class="board-list-item-name htruncate btn-block navbar-btn ">' +
__e(  board.attributes.name ) +
'</span><span class="pull-right hide js-stared-conatiner js-stared-conatiner-' +
__e( board.attributes.id ) +
'">\n\t\t\t';

				if (!_.isUndefined(subscriber) && !_.isEmpty(subscriber) && parseInt(subscriber.attributes.is_subscribe) === 0) {
			;
__p += '\n\t\t\t\t<span title="' +
__e( i18next.t('Click to star this board. It will show up at top of your boards list.') ) +
'" name="unsubscribe" class="icon-star js-star-board" data-subscriber_id="' +
__e( subscriber.attributes.id ) +
'" data-board_id="' +
__e( board.attributes.id ) +
'"></span>\n\t\t  ';

			} else {
		  ;
__p += '\n\t\t\t\t<span title="' +
__e( i18next.t('Click to star this board. It will show up at top of your boards list.') ) +
'" name="subscribe" class="icon-star-empty js-star-board" data-subscriber_id="';
 if(_.isUndefined(subscriber) || _.isEmpty(subscriber)) { ;
__p += '  ';
} else { ;
__p += ' ' +
__e(subscriber.id) +
' ';
} ;
__p += '" data-board_id="' +
__e( board.attributes.id ) +
'"></span>\n\t\t';
		
			}
		;
__p += '\n\t\t\n\t\t</span>\n\t</span>\n</a>\n';
 }else{ ;
__p += '\n <div class="alert alert-info">\n\t' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('boards')] }) ) +
'\n</div>\n';
};
__p += '\t\n\t\t\n  ';

}
return __p
};

this["JST"]["templates/notification_menu"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<li><a href="#" class="js-all-activities"> ' +
__e( i18next.t('All') ) +
'</a></li>\n<li><a href="#" class="js-board-activities">' +
__e( i18next.t('In this board') ) +
'</a></li>';

}
return __p
};

this["JST"]["templates/oauth_applications"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if (!_.isUndefined(oauth_applications) && oauth_applications.length > 0 ) { 
				_.each(oauth_applications, function(oauth_application) { ;
__p += '\n  <div class="clearfix">\n    <div class="col-xs-10">\n      <h4><span class="c">' +
__e( oauth_application.client_name ) +
'</span></h4>\n    </div>\n\t<div class="col-xs-2 pull-right">\n\t  <div class="row-fluid">\n\t\t<div class="pull-right">\n\t\t  <div class="btn-group">\n\t\t\t<button class="btn js-delete" data-client_id="' +
__e( oauth_application.client_id ) +
'" title="' +
__e( i18next.t('Revoke') ) +
'">' +
__e( i18next.t('Revoke') ) +
'</button>\n\t\t  </div>\n\t\t</div>\n\t  </div>\n\t</div>\n  </div>\n\n<hr/>\n';

				}); 
} else { ;
__p += '\n\t<div class="col-xs-12 alert alert-info">\n\t' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('authorized OAuth application')] }) ) +
'</div>\n';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/oauth_client"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="well-lg navbar-btn"></div>\n';
 if (!_.isUndefined(oauth_clients) && oauth_clients.length > 0 ) { 
				_.each(oauth_clients, function(oauth_client) { ;
__p += '\n  <div class="clearfix">\n    <div class="col-xs-10">\n      <h2><span class="c">' +
__e( oauth_client.client_name ) +
'</span></h2>\n\t  <dl class="dl-horizontal">\n\t\t  <dt>' +
__e( i18next.t('Client ID:') ) +
'</dt>\n\t\t  <dd>' +
__e( oauth_client.client_id ) +
'</dd>\n\t\t  <dt>' +
__e( i18next.t('Client Secret:') ) +
'</dt>\n\t\t  <dd>' +
__e( oauth_client.client_secret ) +
'</dd>\n\t  </dl>\n    </div>\n\t<div class="col-xs-2 pull-right">\n\t  <div class="row-fluid">\n\t\t<div class="pull-right">\n\t\t  <div class="btn-group">\n\t\t\t<button class="btn dropdown-toggle js-no-pjax xltriggered" data-toggle="dropdown"><i class="icon-cog"></i><span class="caret"></span></button>\n\t\t\t<ul class="dropdown-menu arrow arrow-right pull-right">\n\t\t\t\t<li><a title="' +
__e( i18next.t('Edit') ) +
'" href="#/oauth_clients/edit/' +
__e( oauth_client.id ) +
'"><i class="icon-edit"></i>' +
__e( i18next.t('Edit') ) +
'</a></li>\n\t\t\t\t';
 if (oauth_client.id == 7742632501382313 || oauth_client.id == 7857596005287233 || oauth_client.id == 6664115227792148) { ;
__p += '\n\t\t\t\t\t<li><a class="js-delete" data-id="' +
__e( oauth_client.id ) +
'" title="' +
__e( i18next.t('Delete') ) +
'" href=""><i class="icon-remove"></i>' +
__e( i18next.t('Delete') ) +
'</a></li>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t</ul>\n\t\t  </div>\n\t\t</div>\n\t  </div>\n\t</div>\n  </div>\n\n<hr/>\n';

				}); 
} else { ;
__p += '\n\t<div class="col-xs-12 text-center alert alert-info">' +
__e( i18next.t('No %s available', { postProcess: 'sprintf', sprintf: ['OAuth application']}) ) +
'</div>\n';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/oauth_client_add"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="well-sm"><h3>' +
__e( i18next.t('Register a new OAuth application') ) +
'</h3></div>\n<form id="oauthClientAddForm" name="oauthClientAddForm" class="form-horizontal col-xs-12">\n  <div class="form-group">\n\t<label class="col-sm-2 control-label col-xs-12" for="inputClientName">' +
__e( i18next.t("Application Name") ) +
'</label>\n\t<div class="col-sm-8 col-xs-12">\n\t\t<input type="text" required name="client_name" id="inputClientName" class="form-control" placeholder="' +
__e( i18next.t('Application Name') ) +
'" title="' +
__e( i18next.t('Application Name') ) +
'">\n\t\t<div><span class="help-block">' +
__e( i18next.t('Something users will recognize and trust') ) +
'</span></div>\n\t</div>\n  </div>\n  <div class="form-group">\n\t<label class="col-sm-2 control-label col-xs-12" for="inputClientUrl">' +
__e( i18next.t("Homepage URL") ) +
'</label>\n\t<div class="col-sm-8 col-xs-12">\n\t\t<input type="text" name="client_url" id="inputClientUrl" class="form-control" placeholder="' +
__e( i18next.t('Homepage URL') ) +
'" title="' +
__e( i18next.t('Homepage URL') ) +
'">\n\t\t<div><span class="help-block">' +
__e( i18next.t('The full URL to your application homepage') ) +
'</span></div>\n\t</div>\n  </div>\n  <div class="form-group">\n\t<label class="col-sm-2 control-label col-xs-12" for="inputRedirectUris">' +
__e( i18next.t("Authorization callback URL") ) +
'</label>\n\t<div class="col-sm-8 col-xs-12">\n\t\t<input type="text" name="redirect_uri" id="inputRedirectUris" class="form-control" placeholder="' +
__e( i18next.t('Authorization callback URL') ) +
'" title="' +
__e( i18next.t('Authorization callback URL') ) +
'">\n\t\t<div><span class="help-block">' +
__e( i18next.t('Your application callback URL. Multiple URL can be separated by space')) +
'</span></div>\n\t</div>\n  </div>\n  <div class="form-group">\n\t<label class="sr-only col-sm-2 control-label col-xs-12" for="submit2">' +
__e( i18next.t('Register application') ) +
'</label>\n\t<div class="col-sm-8">\n\t\t<input type="submit" class="btn btn-primary" id="submitAddClient" value="' +
__e( i18next.t('Register application') ) +
'">\n\t</div>\n  </div>\n</form>';

}
return __p
};

this["JST"]["templates/oauth_client_edit"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="well-sm"><h3>' +
__e( i18next.t('Edit OAuth application') ) +
'</h3></div>\n<form id="oauthClientEditForm" name="oauthClientEditForm" class="form-horizontal col-xs-12">\n  <div class="form-group">\n\t<label class="col-sm-2 control-label col-xs-12" for="inputClientName">' +
__e( i18next.t("Application Name") ) +
'</label>\n\t<div class="col-sm-8 col-xs-12">\n\t\t<input type="text" required name="client_name" value="' +
__e( oauth_client.client_name ) +
'" id="inputClientName" class="form-control" placeholder="' +
__e( i18next.t('Application Name') ) +
'" title="' +
__e( i18next.t('Application Name') ) +
'">\n\t\t<div><span class="help-block">' +
__e( i18next.t('Something users will recognize and trust') ) +
'</span></div>\n\t</div>\n  </div>\n  <div class="form-group">\n\t<label class="col-sm-2 control-label col-xs-12" for="inputClientUrl">' +
__e( i18next.t("Homepage URL") ) +
'</label>\n\t<div class="col-sm-8 col-xs-12">\n\t\t<input type="text" name="client_url" value="' +
__e( oauth_client.client_url ) +
'" id="inputClientUrl" class="form-control" placeholder="' +
__e( i18next.t('Homepage URL') ) +
'" title="' +
__e( i18next.t('Homepage URL') ) +
'">\n\t\t<div><span class="help-block">' +
__e( i18next.t('The full URL to your application homepage') ) +
'</span></div>\n\t</div>\n  </div>\n  <div class="form-group">\n\t<label class="col-sm-2 control-label col-xs-12" for="inputRedirectUris">' +
__e( i18next.t("Authorization callback URL") ) +
'</label>\n\t<div class="col-sm-8 col-xs-12">\n\t\t<input type="text" name="redirect_uri" value="' +
__e( oauth_client.redirect_uri ) +
'" id="inputRedirectUris" class="form-control" placeholder="' +
__e( i18next.t('Authorization callback URL') ) +
'" title="' +
__e( i18next.t('Authorization callback URL') ) +
'">\n\t\t<div><span class="help-block">' +
__e( i18next.t('Your application callback URL. Multiple URL can be separated by space')) +
'</span></div>\n\t</div>\n  </div>\n  <div class="form-group">\n\t<label class="sr-only col-sm-2 control-label col-xs-12" for="submit2">' +
__e( i18next.t('Update application') ) +
'</label>\n\t<div class="col-sm-8">\n\t\t<input type="submit" class="btn btn-primary" id="submitEditClient" value="' +
__e( i18next.t('Update application') ) +
'">\n\t</div>\n  </div>\n</form>';

}
return __p
};

this["JST"]["templates/organization_add"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\n\t<a href="#" class="js-show-organizations-board-from pull-left"><i class="icon-caret-left"></i></a><span class="col-xs-10"><strong> ' +
__e( i18next.t('Create Organization') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a></span></h4>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<form name="OrganizationAddForm" id="OrganizationAddForm">\n\t\t<div class="form-group required">\n\t\t\t<label for="inputOrganizationName">' +
__e( i18next.t('Name') ) +
'</label>\n\t\t\t<input class="form-control input-sm" type="text" maxlength="255" id="inputOrganizationName" name="name" required>\n\t\t</div>\n\t\t<div class="form-group">\n\t\t\t<label for="inputOrganizationDescription">' +
__e( i18next.t('Description') ) +
'</label>\n\t\t\t<textarea class="form-control" type="textarea" id="inputOrganizationDescription" name="description"></textarea>\n\t\t</div>\n\t\t<div class="form-group">\n\t\t\t<input type="submit" value="' +
__e( i18next.t('Add') ) +
'" id="js-add-organization" class="btn  btn-primary">\n\t\t</div>\n\t\t<p>' +
__e( i18next.t('An organization is a group of boards and members.') ) +
'</p>\n\t\t</form>\n</div>';

}
return __p
};

this["JST"]["templates/organization_board"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(board != null){ ;
__p += '\n<div class="panel">\n\t<div class="panel-body bg-warning">\n\t\t<div class="clearfix">\n\t\t\t<h4 class="col-md-9 col-sm-8 col-xs-9 navbar-btn">\n\t\t\t\t<span class="show row navbar-btn">\n\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "starred_board"}))){ ;
__p += '\n\t\t\t\t\t<a class="htruncate btn-block" href="#/board/' +
__e( board.id ) +
'" title="' +
__e( board.attributes.name ) +
'">' +
__e( board.attributes.name) +
'</a>\n\t\t\t\t';
 } else { ;
__p += '\n\t\t\t\t\t' +
__e( board.attributes.name) +
'\t\t\t\t\t\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t</span> \n\t\t\t</h4>\n\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "starred_board"}))){ ;
__p += '\n\t\t\t\t<span class="pull-right dropdown">\n\t\t\t\t\t<a href="#" class="js-board-visibility text-muted h5 show" data-toggle="dropdown">\n\t\t\t\t\t\t';
 if(board.attributes.board_visibility == 0) { ;
__p += '\n\t\t\t\t\t\t\t<span title="' +
__e( i18next.t('Private') ) +
'" class="icon-lock col-lg-2 text-primary"></span>\n\t\t\t\t\t\t';
 } else if(board.attributes.board_visibility == 1) { ;
__p += ' \n\t\t\t\t\t\t\t<span title="' +
__e( i18next.t('Organization') ) +
'" class="icon-group col-lg-2 text-primary"></span>\n\t\t\t\t\t\t';
 } else if(board.attributes.board_visibility == 2) { ;
__p += '\n\t\t\t\t\t\t\t<span title="' +
__e( i18next.t('Public') ) +
'" class="icon-circle col-lg-2 text-primary"></span>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t</a>\n\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t\t<li class="js-visibility-popup js-dropdown-popup dropdown-popup">\n\t\t\t\t\t\t\t<div class="clearfix text-center col-xs-12">\n\t\t\t\t\t\t\t  <a class="js-back-to-board-visibility hide pull-left" href="#"><i class="icon-caret-left"></i></a>\n\t\t\t\t\t\t\t  <span class="col-xs-10"><strong>' +
__e( i18next.t('Change Visibility') ) +
'</strong></span><a class="js-close-span-popover pull-right" href="#"><i class="icon-remove"></i></a>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t</li>\n\t\t\t\t\t\t<li class="col-xs-12 divider js-visibility-list"></li>\n\t\t\t\t\t</ul> \n\t\t\t\t</span>\n\t\t\t';
 } ;
__p += '\n\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "starred_board"}))){ ;
__p += '\n\t\t\t\t';
 if(!_.isEmpty(stared)){ ;
__p += '\n\t\t\t\t\t<a title="' +
__e( i18next.t('Unstar') ) +
'" href="#" class="h5 pull-right js-star-board" name="unstar"><i class="icon-star  text-primary"></i></a>\n\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t<a title="' +
__e( i18next.t('Star') ) +
'" href="#" class="h5 pull-right js-star-board" name="star"><i class="icon-star-empty"></i></a>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t';
 } ;
__p += '\n\t  </div>\n\t  <div class="js-board-inner-view"></div>\n\t\t<ul class="list-unstyled chart-block">\n\t\t';
 
		var style = '';			
		if (board.attributes.background_picture_url) {
			var background_picture_url = board.attributes.background_picture_url.replace("_XXXX.jpg", "_n.jpg");
			style = 'background:url(' + background_picture_url + ') 25% 25%; background-size: cover';
		} else if (board.attributes.background_pattern_url) {
			var background_pattern_url = board.attributes.background_pattern_url.replace("_XXXX.jpg", "_n.jpg");
			style = 'background:url(' + background_pattern_url + ') repeat scroll 0% 0%;';
		} else if (board.attributes.background_color){
			style = 'background:' + board.attributes.background_color;
		}
		;
__p += '\n\t\t';
 if(!_.isEmpty(role_links.where({slug: "starred_board"}))){ ;
__p += '\n\t\t\t<li class="list-group-item clearfix" style="' +
((__t = ( style )) == null ? '' : __t) +
'">\n\t\t\t\t<a class="show" href="#/board/' +
__e( board.id ) +
'">\n\t\t\t\t\t<div id="doughnutChart" class="chart js-chart"></div>\n\t\t\t\t</a>\n\t\t\t</li>\n\t\t';
 } else { ;
__p += '\n\t\t\t<li class="list-group-item clearfix" style="' +
((__t = ( style )) == null ? '' : __t) +
'">\n\t\t\t\t\t<div id="doughnutChart" class="chart js-chart"></div>\n\t\t\t</li>\n\t\t';
 } ;
__p += '\n\t\t</ul>\n\t</div>\n</div>\n';
 }else{ ;
__p += '\n\t<div class="alert alert-info">\n\t' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('boards')] }) ) +
'\n</div>\n';
};


}
return __p
};

this["JST"]["templates/organization_delete_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="col-xs-12 text-center clearfix">\t\n\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Delete Organization') + '?' ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<ul class="list-unstyled">\n\t\t<li class="text-left">\n\t\t\t\t<span class="show">' +
__e( i18next.t('Deleting an organization is permanent. There is no undo.') ) +
'</span>\n\t\t\t\t<div class="col-xs-12 btn-block navbar-btn">\n\t\t\t\t\t<a class="js-delete-organization" title="' +
__e( i18next.t('Delete Organization') ) +
'"><span class=" btn btn-primary">' +
__e( i18next.t('Delete') ) +
'</span></a>\n\t\t\t\t</div>\n\t\t</li>\n\t</ul>\n</div>';

}
return __p
};

this["JST"]["templates/organization_header"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '  <div class="container-fluid">\n\t<div class="navbar-left navbar-btn col-sm-11 col-xs-10 nav  col-lg-5 col-md-4 list-group-item-text">\n\t\t<div class="clearfix row-flex">\n\t\t\t<h2 class="navbar-left navbar-btn col-flex col-flex1 list-group-item-heading list-group-item-text"><span class="navbar-left"><a href="#/" title="' +
__e( SITE_NAME ) +
'"><img src="img/logo.png" alt="[Image: ' +
__e( SITE_NAME ) +
']" title="' +
__e( SITE_NAME ) +
'" class="img-responsive center-block"/></a></span></h2>\n\t\t\t<ul class="list-inline navbar-left h3 navbar-btn navbar-form text-center col-flex col-flex2">\n\t\t\t\t<li>\n\t\t\t\t\t<span class=" pull-left h4 navbar-btn">/</span>\n\t\t\t\t\t<span class="text-muted h4 navbar-btn htruncate col-xs-10 list-group-item-heading list-group-item-text text-left">' +
__e( organization.attributes.name ) +
'</span></li>\n\t\t\t</ul>\n\t\t</div>\n\t</div>\n\t';
 if(!_.isUndefined(authuser.user)){;
__p += '\n  <div class="navbar-right navbar-btn">\n\t<ul class="nav nav-pills navbar-left">\n\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(organization.acl_links.where({slug: "delete_organization",organization_user_role_id: parseInt(organization.organization_user_role_id)})))) { ;
__p += '\n\t  <li class="dropdown">\n\t\t\t<a href="#" title="Delete" class="text-muted list-group-item-text navbar-btn h4 dropdown-toggle" data-toggle="dropdown"><i class="icon-trash"></i></a>\n\t\t\t<ul class="dropdown-menu arrow arrow-right list-unstyled">\n\t\t\t\t\t<li class="col-xs-12 text-center clearfix">\t\t\t\t\t\t\n\t\t\t\t\t\t\t<div class="clearfix"><span class="col-xs-10"><strong>' +
__e( i18next.t('Delete Organization')+'?' ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a></div>\n\t\t\t\t\t</li>\n\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t<li>\n\t\t\t\t\t\t<a class="js-delete-organization show clearfix small well-xs" href="#">\n\t\t\t\t\t\t\t<span class="show text-primary col-xs-12 navbar-btn h5">' +
__e( i18next.t('Remove from organization') ) +
'</span>\n\t\t\t\t\t\t\t<span class="col-xs-12 navbar-btn">' +
__e( i18next.t("Deleting an organization is permanent. Are you sure you want to delete this organization? There is no undo. Boards with this organization won't be deleted. Your boards in this organization will appear in your personal boards list.") ) +
'</span>\n\t\t\t\t\t\t</a>\n\t\t\t\t\t</li>\t\t\t\t\t\n\t\t\t</ul>\n\t\t</li>\n\t';
 } ;
__p += '\t\t  \n\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(organization.acl_links.where({slug: "edit_organization",organization_user_role_id: parseInt(organization.organization_user_role_id)})))) { ;
__p += '\n\t\t  <li class="dropdown navbar-btn">\n\t\t\t<a href="#" title="Edit" class="text-muted dropdown-toggle" data-toggle="dropdown"><span class="icon-pencil"></span></a>\n\t\t\t<ul class="dropdown-menu arrow arrow-right list-unstyled list-inline clearfix pull-right">\n\t\t\t\t<li class="js-dropdown-popup dropdown-popup btn-block">\n\t\t\t\t\t<div class="js-organization-edit-block col-xs-12">\n\t\t\t\t\t\t<form name="OrganizationEditForm" id="OrganizationEditForm"> \n\t\t\t\t\t\t\t<div class="form-group required">\n\t\t\t\t\t\t\t\t<label for="inputOrganizationName">' +
__e( i18next.t('Name') ) +
'</label>\n\t\t\t\t\t\t\t\t<input type="text" id="inputOrganizationName" maxlength="255" name="name" class="form-control input-sm" value="' +
__e( organization.attributes.name ) +
'" required />\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t\t<label for="inputOrganizationWebsite">' +
__e( i18next.t('Website') ) +
'</label>\n\t\t\t\t\t\t\t\t<input type="text" id="inputOrganizationWebsite" name="website_url" class="form-control input-sm" value="' +
((__t = ( organization.attributes.website_url )) == null ? '' : __t) +
'" />\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t\t<label for="inputOrganizationDescription">' +
__e( i18next.t('Description') ) +
'</label>\n\t\t\t\t\t\t\t\t<textarea type="textarea" id="inputOrganizationDescription" class="form-control" name="description">' +
__e( organization.attributes.description ) +
'</textarea>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div class="submit">\n\t\t\t\t\t\t\t\t<input type="submit" value="' +
__e( i18next.t('Save') ) +
'" id="js-edit-organization" class="btn btn-primary" />\n\t\t\t\t\t\t\t\t<input type="button" class="js-close-popover btn btn-default" value="' +
__e( i18next.t('Cancel') ) +
'" />\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t</form>\n\t\t\t\t\t</div>\n\t\t\t\t</li>\n\t\t\t</ul>\t\n\t\t  </li>\n\t  ';
 } ;
__p += '\n\t  ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(organization.acl_links.where({slug: "view_organization_visibility",organization_user_role_id: parseInt(organization.organization_user_role_id)})))) { ;
__p += '\n\t  <li class="dropdown navbar-btn">\n\t\t<a href="" title="';
 if(organization.attributes.organization_visibility == 1){ ;
__p +=
__e( i18next.t('Public') );
 } else { ;
__p +=
__e( i18next.t('Private') );
 } ;
__p += '" class="js-org-visibility-name js-show-organization-visibility-form text-muted dropdown-toggle" data-toggle="dropdown"><span class="js-org-visibility-icon ';
 if(organization.attributes.organization_visibility == 1){ ;
__p += 'icon-circle ';
 } else { ;
__p += 'icon-lock';
 } ;
__p += ' text-muted"></span><span class="h4 js-org-visibility-type">';
 if(organization.attributes.organization_visibility == 1){ ;
__p +=
__e( i18next.t('Public') );
 } else { ;
__p +=
__e( i18next.t('Private') );
 } ;
__p += '</span></a>\n\t\t<ul class="dropdown-menu arrow arrow-right list-unstyled clearfix pull-left js-organization-visibility">\n\t\t';
 } ;
__p += '\t\n\t\t</ul>\n\t  </li>\n\t</ul>\n\t</div>\n';
 } ;


}
return __p
};

this["JST"]["templates/organization_member_confirm_remove_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="col-xs-12 text-center clearfix">\t\n\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Leave organization') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<ul class="list-unstyled">\n\t\t<li>\n\t\t\t<a class="js-delete-organization-member" data-organizations_user_id="' +
__e( organization_users.organizations_user_id ) +
'" href="#">\n\t\t\t\t<span class="show"> ' +
__e( i18next.t('Remove all access to the organization.  The member will remain on all their boards in this organization. They will receive a notification.') ) +
'</span>\n\t\t\t</a>\n\t\t</li>\n\t</ul>\n</div>';

}
return __p
};

this["JST"]["templates/organization_member_permission_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(organization_user.acl_links.where({slug: 'edit_organization_user', organization_user_role_id: parseInt(organization_user.organization_user_role_id)})))) {;
__p += '\n<li class="col-xs-12 text-center clearfix">\n\t<div class="clearfix">\n\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Change permissions') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\n\t</div>\n</li>\n<li class="divider col-xs-12 btn-block"></li>\n';
 _.each(organization_user.organization_user_roles, function(organization_user_role) {;
__p += '\n\t<li class="col-xs-12 btn-block">\n\t\t<a class="h6 navbar-btn js-edit-organization-member-permission" data-organizations_user_id="' +
__e( organization_user.organizations_user_id ) +
'" \n\t\tdata-organizations_id="' +
__e( organization_user.attributes.organization_id ) +
'" data-organization_user_role_id="' +
__e( organization_user_role.id ) +
'" href="#">\n\t\t\t<span class="show text-primary navbar-btn h5">' +
__e( organization_user_role.name ) +
'  \n\t\t\t';
 if(organization_user_role.id == organization_user.attributes.organization_user_role_id){;
__p += '<i class="icon-check well-sm"></i>';
};
__p += '\t\n\t\t\t</span>\n\t\t\t<span class="show">' +
__e( i18next.t('Can view, create and edit org boards, and change settings for the organization.') ) +
'</span>\n\t\t</a>\n\t</li>\n\t<li class="divider col-xs-12 btn-block"></li>\n';
 });
} ;


}
return __p
};

this["JST"]["templates/organization_member_remove_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<li class="col-xs-12">\n\t<a class="show row small well-xs js-delete-organization-member" data-organizations_user_id="' +
__e( organization_users.organizations_user_id ) +
'" href="#">\n\t\t<span class="show text-primary navbar-btn h5">' +
__e( i18next.t('Remove from organization') ) +
'</span>\n\t\t<span class="navbar-btn">' +
__e( i18next.t('Remove all access to the organization.  The member will remain on all their boards in this organization.') ) +
'</span>\n\t</a>\n</li>\n';

}
return __p
};

this["JST"]["templates/organization_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<!-- Main block start -->\n<section class="clearfix row">\n <div class="col-xs-12 h4">\n\t<ul class="nav nav-tabs">\n\t\t<li ';
 if(_.isUndefined(type) || type == 'boards'){ ;
__p += 'class="active" ';
};
__p += '><a href="#/organization/' +
__e(organization.attributes.id) +
'/boards" class="">' +
__e( i18next.t('Boards') ) +
'</a></li>\n\t\t';
		
		if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(organization.acl_links.where({slug: "view_organization_user_listing",organization_user_role_id: parseInt(organization.organization_user_role_id)})) || !_.isEmpty(organization.acl_links.where({slug: "add_organization_user",organization_user_role_id: parseInt(organization.organization_user_role_id)})))) { ;
__p += '\n\t\t\t<li ';
 if(!_.isUndefined(type) && type == 'users'){ ;
__p += 'class="active" ';
};
__p += '><a href="#/organization/' +
__e(organization.attributes.id) +
'/users" class="">' +
__e( i18next.t('Members') ) +
'</a></li>\n\t\t';
 } ;
__p += '\n\t</ul>\n</div>\n  <div class="col-xs-12"> <div class="col-lg-10 col-md-9 col-sm-9 col-xs-12">\n\t<!-- Tab panes -->\n\t\t<div class="tab-content">\n\t\t\t<div class="tab-pane ';
 if(_.isUndefined(type) || type == 'boards'){ ;
__p += 'active';
};
__p += '" id="board">\n\t\t\t\t<section class="clearfix">\n\t\t\t\t  <div class="clearfix" id="js-organization-board-listing"> \n\t\t\t\t  </div>\n\t\t\t\t</section>\n\t\t\t</div>\n\t\t\t<div class="tab-pane js-get-organization-member-lists-response  ';
 if(!_.isUndefined(type) && type == 'users'){ ;
__p += 'active';
};
__p += '" id="member"></div>\n\t\t</div>\n  </div>\n  <form class="col-lg-2 col-md-3 col-sm-3 col-xs-12 js-org-drag" role="form" enctype="multipart/form-data" id="js-org-drag">\n\t<div class="well well-sm clearfix text-center">\n\t';

		var logo_path = "img/default-organization.png"; 
		var is_logo_added = false;
		if (!_.isUndefined(organization.attributes.logo_url) && organization.attributes.logo_url != null) {
			is_logo_added = true;
			logo_path = organization.showImage('Organization', organization.attributes.id, 'medium_thumb' ) +'?'+ new Date().getTime();
		}
	;
__p += '\n\t  <div ';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(organization.acl_links.where({slug: "upload_organization_logo",organization_user_role_id: parseInt(organization.organization_user_role_id)})))) {;
__p += ' id="dropzone" ';
};
__p += 'class="navbar-btn btn-xs">';
 if(!_.isUndefined(authuser.user) && is_logo_added){ ;
__p += '<span class="profile-block show"><i class="js-remove-image icon icon-remove close-block cur"></i><span>';
};
__p += '<img src="' +
((__t = ( logo_path )) == null ? '' : __t) +
'" alt="[Image: ' +
((__t = ( organization.attributes.name)) == null ? '' : __t) +
']" title="' +
((__t = ( organization.attributes.name)) == null ? '' : __t) +
'" class="';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(organization.acl_links.where({slug: "upload_organization_logo",organization_user_role_id: parseInt(organization.organization_user_role_id)})))) {;
__p += 'js-org-image-uploaded ';
};
__p += 'img-responsive img-thumbnail ';
 if(!_.isEmpty(role_links.where({slug: 'starred_board'}))){ ;
__p += 'drag-box';
 } ;
__p += '" id="js-organization-logo-' +
__e(organization.attributes.id ) +
'">\n\t\t<div id="manager-area">\n\t\t\t\n\t\t</div>\n\t\t</span>\n\t\t</span>\n\t\t<div class="drag-drop drag-drop-sm">' +
__e( i18next.t('Drop Files Here') ) +
'</div>\n\t</form>\n\t<span id="org-loader"></span>\n  </div>\n  \n  </div>\n  </div>\n  </div>\n</section>  ';

}
return __p
};

this["JST"]["templates/organization_visibility_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li class="col-xs-12 text-center clearfix">\n\t<div class="clearfix"><span class="col-xs-10"><strong>' +
__e( i18next.t('Select Visibility') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a></div>\n</li>\n<li class="col-xs-12 divider"></li>\n<li class="col-xs-12">\n\t<a class="btn-default show row small well-xs js-edit-organization-visibility-to-private" href="#">\n\t\t<span class="show text-primary col-xs-12 navbar-btn h5">' +
__e( i18next.t('Private') );
 if(organization.attributes.organization_visibility == 2){;
__p += '<i class="icon-check well-sm"></i>';
};
__p += '</span>\n\t\t<span class="col-xs-12 navbar-btn">' +
__e( i18next.t("This organization is private. It's not indexed or visible to those outside the org.") ) +
'</span>\n\t</a>\n</li>\n<li class="divider col-xs-12"></li>\n<li class="col-xs-12">\n\t<a class="show row small well-xs js-edit-organization-visibility-to-public" href="#">\n\t\t<span class="show text-primary col-xs-12 navbar-btn h5">' +
__e( i18next.t('Public') );
 if(organization.attributes.organization_visibility == 1){;
__p += '<i class="icon-check well-sm"></i>';
};
__p += '</span>\n\t\t<span class="col-xs-12 navbar-btn">' +
__e( i18next.t("This organization is public. It's visible to anyone with the link and will show up in search engines like Google. Only those invited to the org can add and edit org boards.") ) +
'</span>\n\t</a>\n</li>';

}
return __p
};

this["JST"]["templates/organizations_board_form_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li class="js-back">\n\t <div class="col-xs-12 text-center clearfix"><a href="#" class="js-back-boards-list pull-left"><i class="icon-caret-left"></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t('Add') ) +
' </strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i> </a></div> \n</li>\n<li class="col-xs-12 navbar-btn divider js-back"></li>\n';
 if(!_.isEmpty(role_links.where({slug: "add_board"}))){ ;
__p += '\n<li class="col-xs-12 btn-block js-back">\n\t<a href="#" class="js-show-board-import-form col-xs-12 navbar-btn h6">\n\t\t<span class="show clearfix text-primary navbar-btn h5">\n\t\t\t<span class="pull-left">' +
__e( i18next.t('Import Board from Trello') ) +
'</span> <span class="cssloader pull-right hide" id="js-board-import-loader"></span>\n\t\t</span>\n\t\t<span class="show">' +
__e( i18next.t('Upload json file exported from Trello.') ) +
'</span>\n\t</a>\n\t<form class="hide" id="js-board-import" enctype="multipart/form-data">\n\t\t<input type="file" name="board_import" class="js-board-import-file"/>\n\t</form>\n</li>\n<li class="col-xs-12 navbar-btn divider js-back"></li>\n<li class="col-xs-12 btn-block js-back">\n\t<a href="#" class="js-show-board-add-form col-xs-12 h6 navbar-btn">\n\t\t<span class="show clearfix text-primary navbar-btn h5">' +
__e( i18next.t('New Board') ) +
'</span>\n\t\t<span class="show">' +
__e( i18next.t('A board is a collection of cards ordered in a list of lists. Use it to manage a project, track a collection, or organize anything.') ) +
'</span>\n\t</a>\n</li>\n<li class="col-xs-12 navbar-btn divider js-back"></li>\n';
 } ;
__p += ' \n';
 if(!_.isEmpty(role_links.where({slug: "add_organization"}))){ ;
__p += '\n<li class="col-xs-12 btn-block js-back">\n\t<a href="#" class="js-show-organizations-add-form col-xs-12 navbar-btn h6">\n\t\t<span class="show clearfix text-primary navbar-btn h5">' +
__e( i18next.t('New Organization') ) +
'</span>\n\t\t<span class="show">' +
__e( i18next.t('An organization is a group of boards and people. Use it to group boards in your company, team, or family.') ) +
'</span>\n\t</a>\n</li>\n';
 } ;


}
return __p
};

this["JST"]["templates/organizations_list_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(organization != null){ ;
__p += '\n<td class="col-lg-5 col-md-3 col-sm-6 col-xs-5">\n\t<div class="media">\n\t\t';

			var logo_path = "img/default-organization.png";
			if (!_.isUndefined(organization.attributes.logo_url) && organization.attributes.logo_url != null) {
				logo_path = organization.showImage('Organization', organization.attributes.id, 'small_thumb' );
			}
		;
__p += '\n\t\t<a data-placement="bottom" title="' +
__e( organization.attributes.name ) +
'" data-toggle="tooltip" class="pull-left" href="#/organization/' +
__e( organization.attributes.id ) +
'"> <img alt="[Images: ' +
__e( organization.attributes.name ) +
']" src="' +
((__t = ( logo_path )) == null ? '' : __t) +
'" height="32" width="32" class="img-rounded"></a>\n\t\t  <div class="media-body">\n\t\t  \t<div class="clearfix">\n\t\t\t\t<a class="pull-left" href="#/organization/' +
__e( organization.attributes.id ) +
'"><h4 class="navbar-btn">' +
__e( organization.attributes.name ) +
'</h4></a>\n\t\t\t</div>\n\t\t\t';
 if(organization.attributes.description != ''){ ;
__p += '\n\t\t\t<div>\n\t\t\t\t<p class="htruncate-l3">' +
__e( organization.attributes.description) +
'</p>\n\t\t\t</div>\n\t\t\t';
};
__p += '\n\t\t  </div>\n\t</div>\n</td>\n<td class="text-right">\n<ul class="list-inline clearfix">\n\t<li class="pull-right ">\n\t\t<ul class="list-inline navbar-btn clearfix">\n\t\t\t<li class="dropdown navbar-btn">\n\t\t\t\t<a title="' +
__e( i18next.t('New Board') ) +
'" class="btn btn-default ';
 if(organization.attributes.organizations_user_count != 0){ ;
__p += 'dropdown-toggle';
}else{;
__p += 'js-no-action';
};
__p += '" href="#" ';
 if(organization.attributes.organizations_user_count != 0){ ;
__p += 'data-toggle="dropdown"';
};
__p += '>' +
__e( organization.attributes.organizations_user_count) +
' ' +
__e( i18next.t('Members') ) +
'</a>\n\t\t\t\t';
 if(organization.attributes.organizations_user_count != 0){ ;
__p += '\n\t\t\t\t\t<ul class="dropdown-menu arrow arrow-left  text-left" role="boards">\n\t\t\t\t\t\t';
 _.each(organization.attributes.organizations_users, function(organizations_user){;
__p += '\n\t\t\t\t\t\t\t<li><a href="#/user/' +
__e(organizations_user.user_id) +
'">' +
__e(organizations_user.username) +
'</a></li>\n\t\t\t\t\t\t';
});
__p += '\n\t\t\t\t\t</ul>\n\t\t\t\t';
};
__p += '\n\t\t\t</li>\n\t\t\t<li class="navbar-btn">\n\t\t\t\t<div class="checkbox-inline dropdown">\n\t\t\t\t\t<a title="' +
__e( i18next.t('Boards') ) +
'" class="btn btn-default ';
 if(organization.attributes.board_count != 0){ ;
__p += 'dropdown-toggle';
}else{;
__p += 'js-no-action';
};
__p += '" href="#" ';
 if(organization.attributes.board_count != 0){ ;
__p += 'data-toggle="dropdown"';
};
__p += '>' +
__e( organization.attributes.board_count) +
' ' +
__e( i18next.t('Boards') ) +
'</a>\n\t\t\t\t\t';
 if(organization.attributes.board_count != 0){ ;
__p += '\n\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right  text-left" role="boards">\n\t\t\t\t\t\t\t';
 _.each(organization.attributes.boards_listing, function(board){;
__p += '\n\t\t\t\t\t\t\t';
 	
								var style = '';		
								if (board.background_picture_url) {
									var background_picture_url = board.background_picture_url.replace("_XXXX.jpg", "_n.jpg");
									style = 'background:url(' + background_picture_url + ') 25% 25%; background-size: cover';
								} else if (board.background_pattern_url) {
									var background_pattern_url = board.background_pattern_url.replace("_XXXX.jpg", "_n.jpg");
									style = 'background:url(' + background_pattern_url + ') repeat scroll 0% 0%;';
								} else if (board.background_color){
									style = 'background-color:' + board.background_color;
								} else {
									style = '';
								}
							;
__p += '\n\t\t\t\t\t\t\t\t<li>\n\t\t\t\t\t\t\t\t\t<a href="#/board/' +
__e(board.id) +
'">\n\t\t\t\t\t\t\t\t\t\t<span style="' +
((__t = ( style )) == null ? '' : __t) +
'" class="preview-thumbnail"></span>\n\t\t\t\t\t\t\t\t\t\t<span class="details navbar-btn">\n\t\t\t\t\t\t\t\t\t\t\t<span title="' +
__e( board.name ) +
'" class="board-list-item-name navbar-btn">' +
__e( board.name ) +
'</span>\n\t\t\t\t\t\t\t\t\t\t</span> \n\t\t\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t';
});
__p += '\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t';
};
__p += '\n\t\t\t\t</div>\n\t\t\t</li>\n\t\t\t<li class="dropdown navbar-btn pull-right">\n\t\t\t\t<a class="btn btn-primary dropdown-toggle js-show-confirm-delete-organization" data-organization_id="' +
__e( organization.attributes.id ) +
'" data-toggle="dropdown" href="#"><span><i class="icon-remove"></i></span><span>' +
__e( i18next.t('Delete') ) +
'</span></a>\n\t\t\t\t<ul class="dropdown-menu dropdown-menu-right arrow arrow-right col-xs-12">\n\t\t\t\t\t<li class="js-show-confirm-delete-organization-response js-dropdown-popup dropdown-popup"></li>\n\t\t\t\t</ul>\n\t\t\t</li>\n\t\t\t</ul>\n\t\t</li>\n\t\t<li class="pull-right text-center">\n\t\t\t<ul class="list-inline navbar-btn clearfix">\n\t\t\t\t<li>\n\t\t\t\t\t<dl class="clearfix text-center list-group-item-heading">\n\t\t\t\t\t\t<dt>\n\t\t\t\t\t\t\t<div class="btn-group navbar-btn list-activity"> <a href="#" class="btn btn-default js-no-action htruncate"><abbr class="timeago" title="' +
__e( organization.attributes.modified ) +
'">' +
__e( organization.attributes.modified ) +
'</abbr></a> </div>\n\t\t\t\t\t\t</dt>\n\t\t\t\t\t\t<dd><h6 class="text-center h4 navbar-btn">' +
__e( i18next.t('Recent activity') ) +
'</h6></dd>\n\t\t\t\t\t</dl></li>\n\t\t\t\t<li>\n\t\t\t\t\t<dl class="clearfix text-center list-group-item-heading">\n\t\t\t\t\t\t<dt>\n\t\t\t\t\t\t\t<div class="btn-group navbar-btn list-activity"> <a href="#" class="btn btn-default js-no-action htruncate"><abbr class="timeago" title="' +
__e( organization.attributes.created ) +
'">' +
__e( organization.attributes.created ) +
'</abbr></a> </div>\n\t\t\t\t\t\t</dt>\n\t\t\t\t\t\t<dd><h6 class="text-center h4 navbar-btn">' +
__e( i18next.t('Created') ) +
'</h6></dd>\n\t\t\t\t\t</dl>\n\t\t\t\t</li>\n\t\t\t\t<li>\n\t\t\t\t\t<dl class="clearfix text-center list-group-item-heading">\n\t\t\t\t\t\t<dt>\n\t\t\t\t\t\t\t<div class="btn-group navbar-btn list-activity"> ';
 if(organization.attributes.username != null){ ;
__p += '<a href="#/user/' +
__e( organization.attributes.user_id ) +
'" class="btn btn-default htruncate" title="' +
__e( organization.attributes.username ) +
'">' +
__e( organization.attributes.username ) +
'</a>';
}else{;
__p += '-';
};
__p += '</div>\n\t\t\t\t\t\t</dt>\n\t\t\t\t\t\t<dd><h6 class="text-center h4 navbar-btn">' +
__e( i18next.t('Owner') ) +
'</h6></dd>\n\t\t\t\t\t</dl>\n\t\t\t\t</li>\n\t\t\t </ul>\n\t\t</li>\n\t</ul>\n</td>\n';
}else{;
__p += '\n\t<div class="alert alert-info">\n\t\t' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('organizations')] }) ) +
'\n\t</div>\n';
};


}
return __p
};

this["JST"]["templates/organizations_lists_header"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div id="js-navbar-default" class="navbar navbar-default" role="navigation">\n  <div class="container-fluid">\n\t<div class="navbar-left">\n\t\t<h1 class="navbar-left navbar-btn list-group-item-text"><span class="navbar-left"><a href="#/" title="' +
__e( SITE_NAME ) +
'"><img src="img/logo.png" alt="[Image: ' +
__e( SITE_NAME ) +
']" title="' +
__e( SITE_NAME ) +
'" class="img-responsive center-block"/></a></span></h1>\n\t\t<ul class="list-inline navbar-left h2 navbar-btn navbar-form text-center">\n\t\t\t<li class="text-muted"><span class="h5">/</span></li>\n\t\t\t<li><span class="text-muted h4">' +
__e( i18next.t('Organizations') ) +
'</span></li>\n\t\t</ul>\n\t\t <div class="pull-left"> <div class="js-dropdown dropdown  docmodal-submenu row">\n              <a data-toggle="dropdown" id="dropdownMenu1" class="dropdown-toggle btn btn-link show" href="#"> <i class="icon-cog h3 text-muted"></i></a>\n              <ul role="menu" class="dropdown-menu arrow">\n                 <li class="text-center text-muted"><strong>' +
__e( i18next.t('Sort') ) +
'</strong></li>\n                 <li class="divider"></li>\n                 <li><a title="' +
__e( i18next.t('Name') ) +
'" href="#" class="js-sort-by" data-field="name">' +
__e( i18next.t('Name') ) +
'</a></li>\n                <li><a title="' +
__e( i18next.t('Owner') ) +
'" href="#" data-field="username" class="js-sort-by">' +
__e( i18next.t('Owner') ) +
'</a></li>\n                <li><a title="' +
__e( i18next.t('Created') ) +
'" href="#" data-field="created" class="js-sort-by">' +
__e( i18next.t('Created') ) +
'</a></li>\n                <li><a title="' +
__e( i18next.t('Users Count') ) +
'" href="#" data-field="organizations_user_count" class="js-sort-by">' +
__e( i18next.t('Users Count') ) +
'</a></li>\n                <li><a title="' +
__e( i18next.t('Board Count') ) +
'" href="#" data-field="board_count" class="js-sort-by">' +
__e( i18next.t('Board Count') ) +
'</a></li>\n              </ul>\n            </div></div>\n\t</div>\n  </div>\n</div>';

}
return __p
};

this["JST"]["templates/organizations_lists_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="panel clearfix col-xs-12">\n\t<div class="table-responsive">\n\t\t<table class="table table-hover table-list">\n\t\t\t<tbody id="js-organizations-list">\n\t\t\t\t\n\t\t\t</tbody>\n\t\t</table>\n\t</div>\n</div>';

}
return __p
};

this["JST"]["templates/organizations_user_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="clearfix">\n';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 ||  !_.isEmpty(organization.acl_links.where({slug: "add_organization_user",organization_user_role_id: parseInt(organization.organization_user_role_id)})))) { ;
__p += '\n<div>\n\t<ul class="list-inline clearfix">\n\t\t<li class="dropdown pull-right">\n\t\t\t<a class="btn btn-primary dropdown-toggle js-add-member-dropdown" data-toggle="dropdown" href="#"><span><i class="icon-plus"></i></span><span>' +
__e( i18next.t('Add Member') ) +
'</span></a>\n\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t<li class="js-add-member-dropdown-load js-dropdown-popup dropdown-popup js-organization-member-search-response">\n\t\t\t\t\t<div>\n\t\t\t\t\t\t<div class="clearfix text-center col-xs-12">\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Members') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a></span></h4>\t\t\t\t\t\t\t\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<div class="col-xs-12 divider"></div>\n\t\t\t\t\t\t<div class="col-xs-12">\n\t\t\t\t\t\t\t<ul class="list-unstyled">\n\t\t\t\t\t\t\t\t<li>\n\t\t\t\t\t\t\t\t  <form method="post" class="text-center">\n\t\t\t\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t\t\t  <label class="sr-only">' +
__e( i18next.t('Search Member') ) +
'</label>\n\t\t\t\t\t\t\t\t\t  <input type="text" autocomplete="off" id="inputOrganizationUserSearch" placeholder="' +
__e( i18next.t('Email or Username') ) +
'" name="email" required class="js-organization-users-search form-control input-sm" title="' +
__e( i18next.t('Email or Username') ) +
'">\n\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t  </form>\n\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</div>\n\t\t\t\t</li>\n\t\t\t\t<li class="small col-xs-12">\n\t\t\t\t\t' +
__e( i18next.t('Search for a person in %s by name or email address.', { postProcess: 'sprintf', sprintf: [SITE_NAME]}) ) +
'\n\t\t\t\t</li>\n\t\t\t</ul>\n\t\t</li>\n\t<ul>\n</div>\n';
 } ;
__p += '\n';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(organization.acl_links.where({slug: "view_organization_user_listing",organization_user_role_id: parseInt(organization.organization_user_role_id)})))) { ;
__p += '\n<div>\n\t<table class="table table-striped table-hover">\n\t\t<tbody>\n\t\t\t';
  if(!_.isEmpty(organizations_users)){
			var organization_user_roles = ["Owner","Editor","Viewer"];
			;
__p += '\n\t\t\t\t';
 _.each(organizations_users.models, function(organizations_user){ ;
__p += '\n\t\t\t\t<tr>\n\t\t\t\t\t<td>\n\t\t\t\t\t\t<div class="clearfix">\n\t\t\t\t\t\t<span class="pull-left navbar-btn">\n\t\t\t\t\t\t\t<a href="#/user/' +
__e(organizations_user.attributes.user_id ) +
'">\n\t\t\t\t\t\t\t';
 if(!_.isEmpty(organizations_user.attributes.profile_picture_path)) {
								 var profile_picture_path = organizations_users.showImage('User', organizations_user.attributes.user_id, 'small_thumb' );
							;
__p += '\n\t\t\t\t\t\t\t\t<img src="' +
((__t = (profile_picture_path)) == null ? '' : __t) +
'" alt="[Image: ' +
__e(organizations_user.attributes.username ) +
']" data-toggle="tooltip" data-placement="bottom" data-original-title="' +
__e( organizations_user.attributes.username ) +
'" class="img-rounded img-responsive">\n\t\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t\t<i data-toggle="tooltip" data-placement="bottom" data-original-title="' +
__e( organizations_user.attributes.username ) +
'" class="avatar avatar-color-194 img-rounded">' +
__e( organizations_user.attributes.initials ) +
'</i>\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t</span>\n\t\t\t\t\t\t\t<div class="pull-left col-xs-10">\n\t\t\t\t\t\t\t\t<h4 class="list-group-item-text list-group-item-heading"><a href="#/user/' +
__e(organizations_user.attributes.user_id ) +
'">' +
__e( organizations_user.attributes.full_name ) +
'</a></h4>\n\t\t\t\t\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "starred_board"}))){ ;
__p += '\n\t\t\t\t\t\t\t\t\t<span class="show"><a href="#/user/' +
__e(organizations_user.attributes.user_id ) +
'">' +
__e( organizations_user.attributes.username ) +
'</a></span>\n\t\t\t\t\t\t\t\t';
 } else { ;
__p += '\n\t\t\t\t\t\t\t\t\t<span class="show">' +
__e( organizations_user.attributes.username ) +
'</span>\n\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t\t<div class="text-right">\n\t\t\t\t\t\t\t\t\t<ul class="list-inline clearfix">\n\t\t\t\t\t\t\t\t\t\t<li class="dropdown navbar-btn">\n\t\t\t\t\t\t\t\t\t\t\t<a title="' +
__e( i18next.t('Boards') ) +
'" class="btn btn-default ';
 if(organizations_user.attributes.user_board_count != 0){ ;
__p += 'dropdown-toggle';
}else{;
__p += 'js-no-action';
};
__p += '" href="#" ';
 if(organizations_user.attributes.user_board_count != 0){ ;
__p += 'data-toggle="dropdown"';
};
__p += '>\n\t\t\t\t\t\t\t\t\t\t\t' +
__e( i18next.t('{{count}} Board', {count: organizations_user.attributes.user_board_count}) ) +
'\n\t\t\t\t\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t\t\t\t\t';
 if(organizations_user.attributes.boards_users != null && organizations_user.attributes.user_board_count != 0){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-left  text-left" role="boards" id="js-user-activity-menu-response-' +
__e( organizations_user.attributes.id) +
'">\n\t\t\t\t\t\t\t\t\t\t\t\t\t';
 _.each(organizations_user.attributes.boards_users, function(boards_user){;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<li>\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "starred_board"}))){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t<a href="#/board/' +
__e(boards_user.board_id) +
'">' +
__e(boards_user.name) +
'</a>\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t';
 } else { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t<a href="#">' +
__e(boards_user.name) +
'</a>\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\t\t\t\t\t\t';
});
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t\t\t\t';
};
__p += '\n\t\t\t\t\t\t\t\t\t\t</li>\t\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\t\t<li class="navbar-btn">\t\t\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\t\t<a title="' +
__e( i18next.t('Activities') ) +
'" class="btn btn-default js-all-user-activities" href="#" data-user_id="' +
__e( organizations_user.attributes.user_id ) +
'">' +
__e( i18next.t('Activities') ) +
'</a>\n\t\t\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(organization.acl_links.where({slug: "edit_organization_user",organization_user_role_id: parseInt(organization.organization_user_role_id)})))) { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user)){;
__p += '\n\t\t\t\t\t\t\t\t\t\t<li class="navbar-btn">              \n\t\t\t\t\t\t\t\t\t\t\t<div class="btn-group text-left navbar-btn dropdown">\n\t\t\t\t\t\t\t\t\t\t\t\t<button type="button" class="btn btn-default dropdown-toggle js-show-organization-member-permission-form js-change-permission-content-' +
__e( organizations_user.attributes.id ) +
'" data-toggle="dropdown" aria-expanded="false" data-organizations_user_id="' +
__e( organizations_user.attributes.id ) +
'">' +
__e( organization_user_roles[organizations_user.attributes.organization_user_role_id - 1]	) +
'</button>\n\t\t\t\t\t\t\t\t\t\t\t\t<button type="button" class="btn btn-default dropdown-toggle js-show-organization-member-permission-form" data-toggle="dropdown" aria-expanded="false" data-organizations_user_id="' +
__e( organizations_user.attributes.id ) +
'">\n\t\t\t\t\t\t\t\t\t\t\t\t\t<span class="caret"></span>\n\t\t\t\t\t\t\t\t\t\t\t\t\t<span class="sr-only">' +
__e( i18next.t('Toggle Dropdown') ) +
'</span>\n\t\t\t\t\t\t\t\t\t\t\t\t</button>      \n\t\t\t\t\t\t\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right js-show-organization-member-permission-form-response pre-scrollable vertical-scrollbar">\n\t\t\t\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\t\t\t<li class="dropdown navbar-btn text-left js-show-confirm-delete-organization-member-dropdown">\n\t\t\t\t\t\t\t\t\t\t\t';
 
											if(!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(organization.acl_links.where({slug: "remove_organization_user",organization_user_role_id: parseInt(organization.organization_user_role_id)})))){;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t\t<a class="btn btn-primary dropdown-toggle js-show-confirm-delete-organization-member" data-organizations_user_id="' +
__e( organizations_user.attributes.id ) +
'" data-toggle="dropdown" href="#"><span><i class="icon-remove"></i></span>\n\t\t\t\t\t\t\t\t\t\t\t\t\t<span>\n\t\t\t\t\t\t\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && organizations_user.attributes.user_id == authuser.user.id) { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
__e( i18next.t('Leave') ) +
'\n\t\t\t\t\t\t\t\t\t\t\t\t\t';
 } else { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
__e( i18next.t('Remove') ) +
'\n\t\t\t\t\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t\t</span></a>\n\t\t\t\t\t\t\t\t\t\t\t\t\t<ul class="dropdown-menu js-dropdown-popup arrow arrow-right">\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<li class="clearfix">\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t<div class="col-xs-12 text-center clearfix">\t\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Remove Member') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<li class="js-show-confirm-delete-organization-member-response divider"></li>\n\t\t\t\t\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t\t';
};
__p += '\n\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</td>\n\t\t\t\t</tr>\n\t\t\t\t';
 }); ;
__p += '\n\t\t\t';
 } else { ;
__p += '\n\t\t\t\t<tr><td class="alert alert-info">' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('members')] }) ) +
'</td></tr>\n\t\t\t';
 } ;
__p += '\n\t\t</tbody>\n\t</table>\n</div>\n';
 } ;
__p += '\n</div>';

}
return __p
};

this["JST"]["templates/qr_code"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 
	var port = (window.location.port) ? ':'+window.location.port : '';
;
__p += '\n<div class="dockmodal-phone" title="' +
__e( i18next.t('View in iOS App') ) +
'" id="phone-block">\n      <div class="clearfix phone-content">\n\t<div class="phone-text">\n\t        <p class="pull-left col-sm-12 col-xs-12">' +
__e( i18next.t('Single unified notifier app to track many Restyaboards.') ) +
'</p>\n\t        <h2 class="pull-left col-sm-12"> ' +
__e( i18next.t('Coming soon.....') ) +
'</h2>\n\t</div>          \n      </div>\n      </div>';

}
return __p
};

this["JST"]["templates/role_settings"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="col-xs-12 js-container-div-role well-lg navbar-btn">\n\t\t<div class="table-responsive navbar-btn">\n\t\t\t<ul id = "myTab" class = "nav nav-tabs">\n\t\t\t   <li class = "active"><a href = "#users" data-toggle = "tab">' +
__e( i18next.t('Users') ) +
'</a></li>\t\t\t   \n\t\t\t   <li><a href = "#boards" data-toggle = "tab">' +
__e( i18next.t('Boards') ) +
'</a></li>\t\t\t\n\t\t\t   <li><a href = "#organizations" data-toggle = "tab">' +
__e( i18next.t('Organizations') ) +
'</a></li>\t\t\t\n\t\t\t</ul>\n\t\t\t<div id = "myTabContent" class = "tab-content">\n\t\t\t   <div class = "tab-pane fade in active" id = "users">\n\t\t\t   <div class="pull-right well-sm dropdown"><a title="Add Role" class="dropdown-toggle" href="#" data-toggle="dropdown"><i class="icon-plus-sign"></i><span>' +
__e( i18next.t('Add Role') ) +
'</span></a>\n\t\t\t    <ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t<li> \n\t\t\t\t\t\t<div class="clearfix text-center col-xs-12">\n\t\t\t\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t("Add Role") ) +
'</strong></span><i class="icon-remove cur"></i>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</li>\n\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t    <form id="RoleAddForm" name="RoleAddForm" class="form-horizontal col-xs-12">\n\t\t\t\t\t\t  <div class="form-group required">\n\t\t\t\t\t\t\t<label class="sr-only control-label" for="inputName">' +
__e( i18next.t("Name") ) +
'</label>\n\t\t\t\t\t\t\t<input type="name" name="name" id="inputName" class="form-control js-role-name" placeholder="' +
__e( i18next.t('Name') ) +
'" required>\n\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t\t<label class="sr-only control-label" for="submitAddRole">' +
__e( i18next.t("Add") ) +
'</label>\n\t\t\t\t\t\t\t<input type="submit" class="btn btn-primary col-xs-12" id="submitAddRole" value="' +
__e( i18next.t('Add') ) +
'">\n\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t</form>\n\t\t\t\t\t </li>\n\t\t\t\t</ul>\n\t\t\t   </div>\n\t\t\t<table class="table js-acl-link-list acl-link-list">\n\t\t\t\t<thead>\n\t\t\t\t\t<th colspan="2" class="col-xs-15">' +
__e( i18next.t('Name') ) +
'</th>\n\t\t\t\t\t';
 roles.each(function(role) { ;
__p += '\n\t\t\t\t\t\t<th class="col-xs-1 text-center">\n\t\t\t\t\t\t<div class="dropdown navbar-right"><a title="Edit Role" class="dropdown-toggle" data-toggle="dropdown">\n\t\t\t\t\t\t' +
__e( i18next.t(role.attributes.name) ) +
'\n\t\t\t\t\t\t<i class="icon-pencil"></i></a>\n\t\t\t    <ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t<li> \n\t\t\t\t\t\t<div class="clearfix text-center col-xs-12">\n\t\t\t\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t("Edit Role") ) +
'</strong></span><i class="icon-remove cur"></i>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</li>\n\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t    <form id="RoleEditForm" name="RoleEditForm" class="form-horizontal col-xs-12">\n\t\t\t\t\t\t\t<input type="hidden" name="id" value="' +
__e( role.attributes.id ) +
'">\n\t\t\t\t\t\t  <div class="form-group required">\n\t\t\t\t\t\t\t<label class="sr-only control-label" for="inputEditName">' +
__e( i18next.t("Name") ) +
'</label>\n\t\t\t\t\t\t\t<input type="name" name="name" id="inputEditName" value="' +
__e( role.attributes.name ) +
'" class="form-control js-role-name" placeholder="' +
__e( i18next.t('Name') ) +
'" required>\n\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t\t<label class="sr-only control-label" for="submitEditRole">' +
__e( i18next.t("Update") ) +
'</label>\n\t\t\t\t\t\t\t<input type="submit" class="btn btn-primary col-xs-12" id="submitEditRole" value="' +
__e( i18next.t('Update') ) +
'">\n\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t</form>\n\t\t\t\t\t </li>\n\t\t\t\t</ul>\n\t\t\t   </div>\n\t\t\t\t\t\t</th>\n\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t</thead>\n\t\t\t\t<tbody class="js-acl-link-list-body acl-link-list">\n\t\t\t\t\t';

						var acl_link_groups = ["Guest", "Users"];     
						var group = '';
						var old_group = '';
						var group_id = '';
						acl_links.each(function(acl_link) {    
							if (acl_link.attributes.is_hide === 1) {
								return;
							}
							acl_link.acl_links_roles.add(acl_link.attributes.acl_links_roles);
							group_id = acl_link.attributes.group_id - 1;
							group = acl_link_groups[group_id];
					;
__p += '\n\t\t\t\t\t\t\t';
 if (group != old_group) { ;
__p += '\n\t\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t\t<td colspan="5" class="text-primary"><h3>' +
__e( group ) +
'</h3></td>\n\t\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<td class="col-xs-1"><div class="invisible"></div></td>\n\t\t\t\t\t\t\t\t<td>' +
__e( acl_link.attributes.name ) +
'</td>\n\t\t\t\t\t\t\t\t';

									roles.each(function(role) {
										var is_enabled = acl_link.acl_links_roles.findWhere({
											role_id: parseInt(role.attributes.id)
										});
								;
__p += '\n\t\t\t\t\t\t\t\t';
 if (role.attributes.id === "1") { ;
__p += '      \n\t\t\t\t\t\t\t\t\t<td class="text-center">\n\t\t\t\t\t\t\t\t\t    ';
 if (acl_link.attributes.is_user_action === 1) { ;
__p += '  \n\t\t\t\t\t\t\t\t\t\t    <div class="checkbox">\n\t\t\t\t\t\t\t\t\t\t\t\t <input type="checkbox" class="cur" checked="checked">\n\t\t\t\t\t\t\t\t\t\t\t\t <label></label>\n                                            </div> \n\t\t\t\t\t\t\t\t\t\t';
 } else { ;
__p += '          \n\t\t\t\t\t\t\t\t\t\t\t<label class="js-update-role" data-table="acl_links_roles" data-acl_link_id="' +
__e( acl_link.attributes.id ) +
'"  data-role_id="' +
__e( role.attributes.id ) +
'" for="acl_link_id_' +
__e( role.attributes.id ) +
'_' +
__e( acl_link.attributes.id ) +
'">-</label>\n\t\t\t\t\t\t\t\t\t\t';
 } ;
__p += '   \n\t\t\t\t\t\t\t\t\t</td>     \n\t\t\t\t\t\t\t\t';
 } else if (role.attributes.id === "2") { ;
__p += '    \n\t\t\t\t\t\t\t\t\t';
 if (acl_link.attributes.is_user_action === 1) { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<td class="text-center">\n\t\t\t\t\t\t\t\t\t\t\t<div class="checkbox">\n\t\t\t\t\t\t\t\t\t\t\t\t<input type="checkbox" class="cur" name="acl_link_id[' +
__e( role.attributes.id ) +
'][' +
__e( acl_link.attributes.id ) +
']" value="' +
__e( acl_link.attributes.id) +
'" ';
 if(!_.isEmpty(is_enabled)) { ;
__p += ' checked="checked" ';
 } ;
__p += ' id="acl_link_id_' +
__e( role.attributes.id ) +
'_' +
__e( acl_link.attributes.id ) +
'"/>\n\t\t\t\t\t\t\t\t\t\t\t\t<label class="js-update-role" data-table="acl_links_roles" data-acl_link_id="' +
__e( acl_link.attributes.id ) +
'"  data-role_id="' +
__e( role.attributes.id ) +
'" for="acl_link_id_' +
__e( role.attributes.id ) +
'_' +
__e( acl_link.attributes.id ) +
'"></label>\n\t\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t\t';
 } else { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<td class="text-center">\n\t\t\t\t\t\t\t\t\t\t\t<label class="js-update-role" data-table="acl_links_roles" data-acl_link_id="' +
__e( acl_link.attributes.id ) +
'"  data-role_id="' +
__e( role.attributes.id ) +
'" for="acl_link_id_' +
__e( role.attributes.id ) +
'_' +
__e( acl_link.attributes.id ) +
'">-</label>\n\t\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t';
 } else if(role.attributes.id === "3") { ;
__p += '\n\t\t\t\t\t\t\t\t\t';
 if (acl_link.attributes.is_guest_action === 1) { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<td class="text-center">\n\t\t\t\t\t\t\t\t\t\t\t<div class="checkbox">\n\t\t\t\t\t\t\t\t\t\t\t\t<input type="checkbox" class="cur" name="acl_link_id[' +
__e( role.attributes.id ) +
'][' +
__e( acl_link.attributes.id ) +
']" value="' +
__e( acl_link.attributes.id) +
'" ';
 if(!_.isEmpty(is_enabled)) { ;
__p += ' checked="checked" ';
 } ;
__p += ' id="acl_link_id_' +
__e( role.attributes.id ) +
'_' +
__e( acl_link.attributes.id ) +
'"/>\n\t\t\t\t\t\t\t\t\t\t\t\t<label class="js-update-role" data-table="acl_links_roles" data-acl_link_id="' +
__e( acl_link.attributes.id ) +
'"  data-role_id="' +
__e( role.attributes.id ) +
'" for="acl_link_id_' +
__e( role.attributes.id ) +
'_' +
__e( acl_link.attributes.id ) +
'"></label>\n\t\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t\t';
 } else { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<td class="text-center">\n\t\t\t\t\t\t\t\t\t\t\t<label class="js-update-role" data-table="acl_links_roles" data-acl_link_id="' +
__e( acl_link.attributes.id ) +
'"  data-role_id="' +
__e( role.attributes.id ) +
'" for="acl_link_id_' +
__e( role.attributes.id ) +
'_' +
__e( acl_link.attributes.id ) +
'">-</label>\n\t\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t';
 } else { ;
__p += '\n\t\t\t\t\t\t\t\t\t';
 if (acl_link.attributes.is_allow_only_to_edit === 1 && acl_link.attributes.is_allow_only_to_guest === 0) { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<td class="text-center">\n\t\t\t\t\t\t\t\t\t\t\t<div class="checkbox">\n\t\t\t\t\t\t\t\t\t\t\t\t<input type="checkbox" class="cur" name="acl_link_id[' +
__e( role.attributes.id ) +
'][' +
__e( acl_link.attributes.id ) +
']" value="' +
__e( acl_link.attributes.id) +
'" ';
 if(!_.isEmpty(is_enabled)) { ;
__p += ' checked="checked" ';
 } ;
__p += ' id="acl_link_id_' +
__e( role.attributes.id ) +
'_' +
__e( acl_link.attributes.id ) +
'"/>\n\t\t\t\t\t\t\t\t\t\t\t\t<label class="js-update-role" data-table="acl_links_roles" data-acl_link_id="' +
__e( acl_link.attributes.id ) +
'"  data-role_id="' +
__e( role.attributes.id ) +
'" for="acl_link_id_' +
__e( role.attributes.id ) +
'_' +
__e( acl_link.attributes.id ) +
'"></label>\n\t\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t\t';
 } else { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<td class="text-center">\n\t\t\t\t\t\t\t\t\t\t\t<label class="js-update-role" data-table="acl_links_roles" data-acl_link_id="' +
__e( acl_link.attributes.id ) +
'"  data-role_id="' +
__e( role.attributes.id ) +
'" for="acl_link_id_' +
__e( role.attributes.id ) +
'_' +
__e( acl_link.attributes.id ) +
'">-</label>\n\t\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t';

							old_group = group;
						});
					;
__p += '\n\t\t\t\t</tbody>\n\t\t\t</table>\n\t\t\t   </div>\n\t\t\t   \n\t\t\t   <div class = "tab-pane fade" id = "boards">\n\t\t\t   <div class="pull-right well-sm dropdown">\n\t\t\t\t\t<a title="Add Board User Role" href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-plus-sign"></i><span>' +
__e( i18next.t('Add Board User Role') ) +
'</span></a>\n\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t\t<li> \n\t\t\t\t\t\t\t<div class="clearfix text-center col-xs-12">\n\t\t\t\t\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t("Add Board User Role") ) +
'</strong></span><i class="icon-remove cur"></i>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t</li>\n\t\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t\t\t<form id="BoardUserRoleAddForm" name="BoardUserRoleAddForm" class="form-horizontal col-xs-12">\n\t\t\t\t\t\t\t  <div class="form-group required">\n\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="inputBoardName">' +
__e( i18next.t("Name") ) +
'</label>\n\t\t\t\t\t\t\t\t<input type="name" name="name" id="inputBoardName" class="form-control js-role-name" placeholder="' +
__e( i18next.t('Name') ) +
'" required>\n\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t  <div class="form-group required">\n\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="inputBoardDescription">' +
__e( i18next.t("Description") ) +
'</label>\n\t\t\t\t\t\t\t\t<textarea name="description" id="inputBoardDescription" class="form-control js-role-name" placeholder="' +
__e( i18next.t('Description') ) +
'"></textarea>\n\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="submitAddBoardUserRole">' +
__e( i18next.t("Add") ) +
'</label>\n\t\t\t\t\t\t\t\t<input type="submit" class="btn btn-primary col-xs-12" id="submitAddBoardUserRole" value="' +
__e( i18next.t('Add') ) +
'">\n\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t</form>\n\t\t\t\t\t\t </li>\n\t\t\t\t\t</ul>\n\t\t\t   </div>\n\t\t\t<table class="table js-acl-link-list acl-link-list">\n\t\t\t\t<thead>\n\t\t\t\t\t<th colspan="2" class="col-xs-15">' +
__e( i18next.t('Name') ) +
'</th>\n\t\t\t\t\t';
 board_user_roles.each(function(board_user_role) { ;
__p += '\n\t\t\t\t\t\t<th class="col-xs-1 text-center">\n\t\t\t\t\t\t<div class="dropdown navbar-right">\n\t\t\t\t\t\t\t<a title="Edit Board User Role" class="dropdown-toggle" data-toggle="dropdown">' +
__e( i18next.t(board_user_role.attributes.name) ) +
'<i class="icon-pencil"></i></a>\n\t\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t\t\t\t<li> \n\t\t\t\t\t\t\t\t\t<div class="clearfix text-center col-xs-12">\n\t\t\t\t\t\t\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t("Edit Board User Role") ) +
'</strong></span><i class="icon-remove cur"></i>\n\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t\t\t\t\t<form id="BoardUserRoleEditForm" name="BoardUserRoleEditForm" class="form-horizontal col-xs-12">\n\t\t\t\t\t\t\t\t\t  <input type="hidden" name="id" value="' +
__e( board_user_role.attributes.id ) +
'">\n\t\t\t\t\t\t\t\t\t  <div class="form-group required">\n\t\t\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="inputEditBoardName">' +
__e( i18next.t("Name") ) +
'</label>\n\t\t\t\t\t\t\t\t\t\t<input type="name" name="name" value="' +
__e( board_user_role.attributes.name ) +
'" id="inputEditBoardName" class="form-control js-role-name" placeholder="' +
__e( i18next.t('Name') ) +
'" required>\n\t\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t\t  <div class="form-group required">\n\t\t\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="inputEditBoardDescription">' +
__e( i18next.t("Description") ) +
'</label>\n\t\t\t\t\t\t\t\t\t\t<textarea name="description" id="inputEditBoardDescription" class="form-control js-role-name" placeholder="' +
__e( i18next.t('Description') ) +
'">' +
__e( board_user_role.attributes.description ) +
'</textarea>\n\t\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="submitEditBoardUserRole">' +
__e( i18next.t("Update") ) +
'</label>\n\t\t\t\t\t\t\t\t\t\t<input type="submit" class="btn btn-primary col-xs-12" id="submitEditBoardUserRole" value="' +
__e( i18next.t('Update') ) +
'">\n\t\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t\t</form>\n\t\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t   </div>\n\t\t\t\t\t\t</th>\n\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t</thead>\n\t\t\t\t<tbody class="js-acl-link-list-body acl-link-list">\n\t\t\t\t\t';

						var acl_board_links_groups = ["Boards","Lists","Cards"];
						var group = '';
						var old_group = '';
						var group_id = '';
						acl_board_links.each(function(acl_board_link) {
							if (acl_board_link.attributes.is_hide === 1) {
								return;
							}
							acl_board_link.acl_board_links_boards_user_roles.add(acl_board_link.attributes.acl_board_links_boards_user_roles);
							group_id = acl_board_link.attributes.group_id - 2;
							group = acl_board_links_groups[group_id];
					;
__p += '\n\t\t\t\t\t\t\t';
 if ( group != old_group) { ;
__p += '\n\t\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t\t<td colspan="5" class="text-primary"><h3>' +
__e( group ) +
'</h3></td>\n\t\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<td class="col-xs-1"><div class="invisible"></div></td>\n\t\t\t\t\t\t\t\t<td>' +
__e( acl_board_link.attributes.name ) +
'</td>\n\t\t\t\t\t\t\t\t';

									board_user_roles.each(function(board_user_role) {
										var is_enabled = acl_board_link.acl_board_links_boards_user_roles.findWhere({
											board_user_role_id: parseInt(board_user_role.attributes.id)
										});
								;
__p += '\n\t\t\t\t\t\t\t\t\t\t<td class="text-center">\n\t\t\t\t\t\t\t\t\t\t\t<div class="checkbox">\n\t\t\t\t\t\t\t\t\t\t\t\t<input type="checkbox" class="cur" name="acl_link_id[' +
__e( board_user_role.attributes.id ) +
'][' +
__e( acl_board_link.attributes.id ) +
']" value="' +
__e( acl_board_link.attributes.id) +
'" ';
 if(!_.isEmpty(is_enabled)) { ;
__p += ' checked="checked" ';
 } ;
__p += ' id="acl_link_board_id_' +
__e( board_user_role.attributes.id ) +
'_' +
__e( acl_board_link.attributes.id ) +
'"/>\n\t\t\t\t\t\t\t\t\t\t\t\t<label class="js-update-role" data-table="acl_board_links_boards_user_roles" data-acl_link_id="' +
__e( acl_board_link.attributes.id ) +
'"  data-role_id="' +
__e( board_user_role.attributes.id ) +
'" for="acl_link_board_id_' +
__e( board_user_role.attributes.id ) +
'_' +
__e( acl_board_link.attributes.id ) +
'"></label>\n\t\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t\t';
 old_group = group; ;
__p += '\n\t\t\t\t\t';

						});
					;
__p += '\n\t\t\t\t</tbody>\n\t\t\t</table>\n\t\t\t   </div>\n\t\t\t   \n\t\t\t   <div class = "tab-pane fade" id = "organizations">\n\t\t\t   <div class="pull-right well-sm dropdown"><a title="Add Organization User Role" href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-plus-sign"></i><span>' +
__e( i18next.t('Add Organization User Role') ) +
'</span></a>\n\t\t\t   <ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t\t<li> \n\t\t\t\t\t\t\t<div class="clearfix text-center col-xs-12">\n\t\t\t\t\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t("Add Organization User Role") ) +
'</strong></span><i class="icon-remove cur"></i>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t</li>\n\t\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t\t\t<form id="OrganizationUserRoleAddForm" name="OrganizationUserRoleAddForm" class="form-horizontal col-xs-12">\n\t\t\t\t\t\t\t  <div class="form-group required">\n\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="inputOrganizationName">' +
__e( i18next.t("Name") ) +
'</label>\n\t\t\t\t\t\t\t\t<input type="name" name="name" id="inputOrganizationName" class="form-control js-role-name" placeholder="' +
__e( i18next.t('Name') ) +
'" required>\n\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t  <div class="form-group required">\n\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="inputOrganizationDescription">' +
__e( i18next.t("Description") ) +
'</label>\n\t\t\t\t\t\t\t\t<textarea name="description" id="inputOrganizationDescription" class="form-control js-role-name" placeholder="' +
__e( i18next.t('Description') ) +
'"></textarea>\n\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="submitAddOrganizationUserRole">' +
__e( i18next.t("Add") ) +
'</label>\n\t\t\t\t\t\t\t\t<input type="submit" class="btn btn-primary col-xs-12" id="submitAddOrganizationUserRole" value="' +
__e( i18next.t('Add') ) +
'">\n\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t</form>\n\t\t\t\t\t\t </li>\n\t\t\t\t\t</ul>\n\t\t\t   </div>\n\t\t\t\t<table class="table js-acl-link-list acl-link-list">\n\t\t\t\t<thead>\n\t\t\t\t\t<th colspan="2" class="col-xs-15">' +
__e( i18next.t('Name') ) +
'</th>\n\t\t\t\t\t';
 organization_user_roles.each(function(organization_user_role) { ;
__p += '\n\t\t\t\t\t\t<th class="col-xs-1 text-center">\n\t\t\t\t\t\t\t<div class="dropdown navbar-right"><a title="Edit Organization User Role" class="dropdown-toggle" data-toggle="dropdown">' +
__e( i18next.t(organization_user_role.attributes.name) ) +
'<i class="icon-pencil"></i></a>\n\t\t\t\t\t\t\t   <ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t\t\t\t\t\t<li> \n\t\t\t\t\t\t\t\t\t\t\t<div class="clearfix text-center col-xs-12">\n\t\t\t\t\t\t\t\t\t\t\t\t<span class="col-xs-10"><strong>' +
__e( i18next.t("Edit Organization User Role") ) +
'</strong></span><i class="icon-remove cur"></i>\n\t\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\t\t\t<li class="col-xs-12 divider"></li>\n\t\t\t\t\t\t\t\t\t\t<li class="col-xs-12">\n\t\t\t\t\t\t\t\t\t\t\t<form id="OrganizationUserRoleEditForm" name="OrganizationUserRoleEditForm" class="form-horizontal col-xs-12">\n\t\t\t\t\t\t\t\t\t\t\t<input type="hidden" name="id" value="' +
__e( organization_user_role.attributes.id ) +
'">\n\t\t\t\t\t\t\t\t\t\t\t  <div class="form-group required">\n\t\t\t\t\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="inputEditOrganizationName">' +
__e( i18next.t("Name") ) +
'</label>\n\t\t\t\t\t\t\t\t\t\t\t\t<input type="name" name="name" id="inputEditOrganizationName" value="' +
__e( organization_user_role.attributes.name ) +
'" class="form-control js-role-name" placeholder="' +
__e( i18next.t('Name') ) +
'" required>\n\t\t\t\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t\t\t\t  <div class="form-group required">\n\t\t\t\t\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="inputEditOrganizationDescription">' +
__e( i18next.t("Description") ) +
'</label>\n\t\t\t\t\t\t\t\t\t\t\t\t<textarea name="description" id="inputEditOrganizationDescription" class="form-control js-role-name" placeholder="' +
__e( i18next.t('Description') ) +
'">' +
__e( organization_user_role.attributes.description ) +
'</textarea>\n\t\t\t\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t\t\t\t\t\t\t<label class="sr-only control-label" for="submitEditOrganizationUserRole">' +
__e( i18next.t("Update") ) +
'</label>\n\t\t\t\t\t\t\t\t\t\t\t\t<input type="submit" class="btn btn-primary col-xs-12" id="submitEditOrganizationUserRole" value="' +
__e( i18next.t('Update') ) +
'">\n\t\t\t\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t\t\t\t</form>\n\t\t\t\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t   </div>\n\t\t\t\t\t\t</th>\n\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t</thead>\n\t\t\t\t<tbody class="js-acl-link-list-body acl-link-list">\n\t\t\t\t\t';

						var acl_organization_links_groups = ["Organizations"];
						var group = '';
						var old_group = '';
						var group_id = '';
						acl_organization_links.each(function(acl_organization_link) {
							acl_organization_link.acl_organization_links_organizations_user_roles.add(acl_organization_link.attributes.acl_organization_links_organizations_user_roles);
							group_id = acl_organization_link.attributes.group_id - 5;
							group = acl_organization_links_groups[group_id];
					;
__p += '\n\t\t\t\t\t\t';
 if (group != old_group) { ;
__p += '\n\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<td colspan="5" class="text-primary"><h3>' +
__e( group ) +
'</h3></td>\n\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t<td class="col-xs-1"> <div class="invisible"></div></td>\n\t\t\t\t\t\t\t<td>' +
__e( acl_organization_link.attributes.name) +
'</td>\n\t\t\t\t\t\t\t';
 
								organization_user_roles.each(function(organization_user_role) {									
									var is_enabled = acl_organization_link.acl_organization_links_organizations_user_roles.findWhere({
										organization_user_role_id: parseInt(organization_user_role.attributes.id)
									});
							;
__p += '\n\t\t\t\t\t\t\t\t\t<td class="text-center">\n\t\t\t\t\t\t\t\t\t\t<div class="checkbox">\n\t\t\t\t\t\t\t\t\t\t\t<input type="checkbox" class="cur" name="acl_link_id[' +
__e( organization_user_role.attributes.id ) +
'][' +
__e( acl_organization_link.attributes.id ) +
']" value="' +
__e( acl_organization_link.attributes.id) +
'" ';
 if (!_.isEmpty(is_enabled)) { ;
__p += ' checked="checked" ';
 } ;
__p += ' id="acl_link_org_id_' +
__e( organization_user_role.attributes.id ) +
'_' +
__e( acl_organization_link.attributes.id ) +
'"/>\n\t\t\t\t\t\t\t\t\t\t\t<label class="js-update-role" data-table="acl_organization_links_organizations_user_roles" data-acl_link_id="' +
__e( acl_organization_link.attributes.id ) +
'"  data-role_id="' +
__e( organization_user_role.attributes.id ) +
'" for="acl_link_org_id_' +
__e( organization_user_role.attributes.id ) +
'_' +
__e( acl_organization_link.attributes.id ) +
'"></label>\n\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t';
 old_group = group; ;
__p += '\n\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t</tbody>\n\t\t\t</table>\n\t\t\t   </div>\n\t\t\t</div>\n\t\t</div>\n</div>';

}
return __p
};

this["JST"]["templates/roles"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<td>\n\t' +
__e( acl_link.attributes.name) +
'\n</td>\n<td class="text-right">\n\t';
 
	  for(var i = 1; i <= 3; i++){
	  var is_enabled = acl_link.acl_links_roles.findWhere({
            role_id: i
        })
	;
__p += '\n\t<div class="checkbox">\n\t<input type="checkbox" name="acl_link_id[' +
__e( i ) +
'[' +
__e( acl_link.attributes.id ) +
']" value="' +
__e( acl_link.attributes.id) +
'" ';
 if(!_.isEmpty(is_enabled)) { ;
__p += ' checked="checked" ';
 } ;
__p += '/>\n\t</div> \n\t';
};
__p += '\n</td>\n';

}
return __p
};

this["JST"]["templates/search_page_result"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '\t\t\t<div class="clearfix bg-grey search-block row"  id="search-page-result">\n\t\t\t  <div class="clearfix">\n\t\t\t\t<ul class="list-inline text-right navbar-btn">\n\t\t\t\t\t<li>\n\t\t\t\t\t\t<a href="http://restya.com/board/docs/search?utm_source=Restyaboard&utm_medium=web&utm_campaign=search" title="Search Help" target="_blank">Search Help</a>\n\t\t\t\t\t</li>\n\t\t\t\t\t<li class="js-search-block-close">\n\t\t\t\t\t\t<a href="javascript:void(0)" class="text-muted" title="Close"><i class="icon-remove text-muted h2"></i></a>\n\t\t\t\t\t</li>\n\t\t\t\t</ul>\n\t\t\t\t';
 if(!_.isEmpty(search_result)) { ;
__p += '\n\t\t\t\t<div class="well-sm col-xs-12">\n\t\t\t\t&nbsp;Search results for <strong>' +
__e( search_result.search_term ) +
'</strong>\n\t\t\t\t</div>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t<div class="col-xs-12 navbar-btn">\n\t\t\t\t\t<ul class="list-unstyled navbar-btn">\n\t\t\t\t\t\t\t';
 if(!_.isUndefined(search_result.boards)) { ;
__p += '\n\t\t\t\t\t\t\t<li>\n\t\t\t\t\t\t\t    <strong>Matched in ' +
__e( search_result.metadata.boards.count ) +
' boards</strong>\n\t\t\t\t\t\t\t\t<div class="panel clearfix">\n\t\t\t\t\t\t\t\t\t<ul class="list-inline panel-body">\n\t\t\t\t\t\t\t\t\t\t';
 _.each(search_result.boards, function(item, key) { ;
__p += ' \n\t\t\t\t\t\t\t\t\t\t\t<li class="col-sm-2 navbar-btn"><span class="pull-left navbar-btn">' +
__e( (key + 1) ) +
'. &nbsp;</span><a class="thumbnail list-group-item-text text-center htruncate" title="' +
__e( item.board_name ) +
'" href="#/board/' +
__e( item.board_id ) +
'">' +
__e( item.board_name ) +
'</a></li>\n\t\t\t\t\t\t\t\t\t\t';
 }); ;
__p += ' \n\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t';

							 if (search_result.metadata.boards.count > 10 && search_result.metadata.boards.count > ((search_result.metadata.boards.page > 1)? (parseInt(search_result.metadata.boards.page) * 20) - 10 : search_result.metadata.boards.page * 10)) {
							 ;
__p += '\n\t\t\t\t\t\t\t <li class="pull-right js-load-more-search" data-search="' +
__e( search_result.search_term ) +
'" data-page="' +
__e( parseInt(search_result.metadata.boards.page) + 1 ) +
'" data-for="boards">\n\t\t\t\t\t\t\t <a href="javascript:void(0)" class="Load More Boards">Load More Boards</a>\n\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t ';

							 }
							 ;
__p += '\n\t\t\t\t\t\t\t <hr class="col-xs-12">\n\t\t\t\t\t\t\t';
 } ;
__p += ' \n\t\t\t\t\t\t\t';
 if(!_.isUndefined(search_result.lists)) { ;
__p += '\n\t\t\t\t\t\t\t<li>\n\t\t\t\t\t\t\t    <strong>Matched in ' +
__e( search_result.metadata.lists.count ) +
' lists</strong>\n\t\t\t\t\t\t\t\t<div class="panel clearfix">\n\t\t\t\t\t\t\t\t\t<ul class="list-inline panel-body">\n\t\t\t\t\t\t\t\t\t\t';
 _.each(search_result.lists, function(item, key) { ;
__p += ' \n\t\t\t\t\t\t\t\t\t\t\t<li class="col-sm-2"><span class="pull-left navbar-btn">' +
__e( (key + 1) ) +
'. &nbsp;</span><a class="thumbnail list-group-item-text text-center htruncate" title="' +
__e( item.list_name ) +
'" href="#/board/' +
__e( item.board_id ) +
'">' +
((__t = ( item.board_name + ' &raquo; ' + item.list_name )) == null ? '' : __t) +
'</a></li>\n\t\t\t\t\t\t\t\t\t\t';
 }); ;
__p += ' \n\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t<hr class="col-xs-12">\n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t';

							 if (search_result.metadata.lists.count > 10 && search_result.metadata.lists.count > ((search_result.metadata.lists.page > 1)? (parseInt(search_result.metadata.lists.page) * 20) - 10 : search_result.metadata.lists.page * 10)) {
							 ;
__p += '\n\t\t\t\t\t\t\t <li class="pull-right js-load-more-search" data-search="' +
__e( search_result.search_term ) +
'" data-page="' +
__e( parseInt(search_result.metadata.lists.page) + 1 ) +
'" data-for="lists">\n\t\t\t\t\t\t\t <a href="javascript:void(0)" class="Load More Lists">Load More Lists</a>\n\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t ';

							 }
							 ;
__p += '\n\t\t\t\t\t\t\t';
 } ;
__p += ' \n\t\t\t\t\t\t\t';
 if(!_.isUndefined(search_result.cards_labels)) { ;
__p += '\n\t\t\t\t\t\t\t  <li class="list-view clearfix">\n\t\t\t\t\t\t\t  <strong>Matched in ' +
__e( search_result.metadata.cards_labels.count ) +
' labels</strong>\n\t\t\t\t\t\t\t  ';
 _.each(search_result.cards_labels, function(item, key) { ;
__p += ' \n\t\t\t\t\t\t\t  <div class="col-xs-12 panel">\n\t\t\t\t\t\t\t\t<ul class="list-inline row panel-body js-open-search-model-card-view cur" data-board_id="' +
__e( item.board_id) +
'" data-list_id="' +
__e( item.list_id) +
'" data-card_id="' +
__e( item.id) +
'">\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1"><span title="#' +
__e( item.id ) +
'">#' +
__e( item.id ) +
'</span></li>\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1 htruncate"><span title="' +
__e( item.board_name ) +
'">' +
__e( item.board_name ) +
'</a></li>\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1 htruncate"><span title="' +
__e( item.name ) +
'" >' +
__e( item.name ) +
'</a></li>\n\t\t\t\t\t\t\t\t\t  <li><span title="Votes"><i class="icon-thumbs-up"></i><small>' +
__e( item.vote_count ) +
'</small></span> </li>\n\t\t\t\t\t\t\t\t\t  <li><span title="Attachments"><i class="icon-paper-clip"></i><small>' +
__e( item.attachment_count ) +
'</small></span> </li>\n\t\t\t\t\t\t\t\t\t   <li><span title="Comments"><i class="icon-comment"></i><small>' +
__e( item.attachment_count ) +
'</small></span></li>\n\t\t\t\t\t\t\t\t\t   <li><small><span class="icon-list-ul"></span><span>' +
__e( item.checklist_item_completed_count ) +
'/' +
__e( item.checklist_item_count ) +
'</span></small></li>\n\t\t\t\t\t\t\t\t\t  ';
 if(!_.isUndefined(item.due_date) && item.due_date != null){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t  <li><a title="Due date" href="javascript:void(0)"><small><span class="label label-danger">\n\t\t\t\t\t\t\t\t\t\t  ';

											card_due_date = item.due_date;
											var today = new Date();
											var last_day = new Date(today.getFullYear(), today.getMonth() + 1, 0);
											var next_month_last_day = new Date(today.getFullYear(), today.getMonth() + 2, 0);
											var due_date = new Date(card_due_date);
											var diff = Math.floor(due_date.getTime() - today.getTime());
											var day = 1000 * 60 * 60 * 24;var days = Math.floor(diff / day);
											var months = Math.floor((days + (today.getDate() + 1)) / next_month_last_day.getDate());var years = Math.floor(months / 12);var week = days - (6 - (today.getDay()));
											var label = 'label-default';
											if (years < 0 || months < 0 || days <= -1) {
												label = 'label-danger';
											}
											var date_time = item.due_date.split('T');
											date_time = date_time[0].split(' '); 
										  ;
__p += '\n\t\t\t\t\t\t\t\t\t\t  ' +
((__t = ( dateFormat(date_time[0], "mediumDate") )) == null ? '' : __t) +
'\n\t\t\t\t\t\t\t\t\t\t  </span></small></a></li>\n\t\t\t\t\t\t\t\t\t  ';
 } ;
__p += ' \n\t\t\t\t\t\t\t\t\t  <li class="col-md-6 pull-right">';
 if (!_.isUndefined(item.highlight)) { ;
__p += '<p class="htruncate">' +
((__t = ( item.highlight['cards_labels.name'] )) == null ? '' : __t) +
'</p>';
 } ;
__p += '</li>\n\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t  ';
 }); ;
__p += ' \n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t';

							 if (search_result.metadata.cards_labels.count > 10 && search_result.metadata.cards_labels.count > ((search_result.metadata.cards_labels.page > 1)? (parseInt(search_result.metadata.cards_labels.page) * 20) - 10 : search_result.metadata.cards_labels.page * 10)) {
							 ;
__p += '\n\t\t\t\t\t\t\t <li class="pull-right js-load-more-search" data-search="' +
__e( search_result.search_term ) +
'" data-page="' +
__e( parseInt(search_result.metadata.cards_labels.page) + 1 ) +
'" data-for="cards_labels">\n\t\t\t\t\t\t\t <a href="javascript:void(0)" class="Load More Labels">Load More Labels</a>\n\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t ';

							 }
							 ;
__p += '\n\t\t\t\t\t\t\t<hr class="col-xs-12">\n\t\t\t\t\t\t\t';
 } ;
__p += ' \n\t\t\t\t\t\t\t';
 if(!_.isUndefined(search_result.comments)) { ;
__p += '\n\t\t\t\t\t\t\t   <li class="list-view"><strong>Matched in ' +
__e( search_result.metadata.comments.count ) +
' Comments</strong>\n\t\t\t\t\t\t\t    ';
 _.each(search_result.comments, function(item, key) { ;
__p += ' \n\t\t\t\t\t\t\t\t  <div class="col-xs-12 panel">\n\t\t\t\t\t\t\t\t\t<ul class="list-inline row panel-body js-open-search-model-card-view cur" data-board_id="' +
__e( item.board_id) +
'" data-list_id="' +
__e( item.list_id) +
'" data-card_id="' +
__e( item.id) +
'">\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1"><span title="#' +
__e( item.id ) +
'">#' +
__e( item.id ) +
'</span></li>\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1 htruncate"><span title="' +
__e( item.board_name ) +
'" >' +
__e( item.board_name ) +
'</span></li>\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1 htruncate"><span title="' +
__e( item.name ) +
'">' +
__e( item.name ) +
'</span></li>\n\t\t\t\t\t\t\t\t\t  <li><span title="Votes"><i class="icon-thumbs-up"></i><small>' +
__e( item.vote_count ) +
'</small></span> </li>\n\t\t\t\t\t\t\t\t\t  <li><a title="Attachments" href="javascript:void(0)"><i class="icon-paper-clip"></i><small>' +
__e( item.attachment_count ) +
'</small></a> </li>\n\t\t\t\t\t\t\t\t\t   <li><a title="Comments" href="javascript:void(0)"><i class="icon-comment"></i><small>' +
__e( item.attachment_count ) +
'</small></a></li>\n\t\t\t\t\t\t\t\t\t   <li><small><span class="icon-list-ul"></span><span>' +
__e( item.checklist_item_completed_count ) +
'/' +
__e( item.checklist_item_count ) +
'</span></small></li>\n\t\t\t\t\t\t\t\t\t  ';
 if(!_.isUndefined(item.due_date) && item.due_date != null){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t  <li><a title="Due date" href="javascript:void(0)"><small><span class="label label-danger">\n\t\t\t\t\t\t\t\t\t\t  ';

											card_due_date = item.due_date;
											var today = new Date();
											var last_day = new Date(today.getFullYear(), today.getMonth() + 1, 0);
											var next_month_last_day = new Date(today.getFullYear(), today.getMonth() + 2, 0);
											var due_date = new Date(card_due_date);
											var diff = Math.floor(due_date.getTime() - today.getTime());
											var day = 1000 * 60 * 60 * 24;var days = Math.floor(diff / day);
											var months = Math.floor((days + (today.getDate() + 1)) / next_month_last_day.getDate());var years = Math.floor(months / 12);var week = days - (6 - (today.getDay()));
											var label = 'label-default';
											if (years < 0 || months < 0 || days <= -1) {
												label = 'label-danger';
											}
											var date_time = item.due_date.split('T');
											date_time = date_time[0].split(' '); 
										  ;
__p += '\n\t\t\t\t\t\t\t\t\t\t  ' +
((__t = ( dateFormat(date_time[0], "mediumDate") )) == null ? '' : __t) +
'\n\t\t\t\t\t\t\t\t\t\t  </span></small></a></li>\n\t\t\t\t\t\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t  <li class="col-md-6 pull-right">';
 if (!_.isUndefined(item.highlight)) { ;
__p += '<p class="htruncate">' +
((__t = ( item.highlight['activities.comment'] )) == null ? '' : __t) +
'</p>';
 } ;
__p += '</li>\n\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t  ';
 }); ;
__p += '\n\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t ';

							 if (search_result.metadata.comments.count > 10 && search_result.metadata.comments.count > ((search_result.metadata.comments.page > 1)? (parseInt(search_result.metadata.comments.page) * 20) - 10 : search_result.metadata.comments.page * 10)) {
							 ;
__p += '\n\t\t\t\t\t\t\t <li class="pull-right js-load-more-search" data-search="' +
__e( search_result.search_term ) +
'" data-page="' +
__e( parseInt(search_result.metadata.comments.page) + 1 ) +
'" data-for="cards_comments">\n\t\t\t\t\t\t\t <a href="javascript:void(0)" class="Load More Comments">Load More Comments</a>\n\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t ';

							 }
							 ;
__p += '\n\t\t\t\t\t\t\t <hr class="col-xs-12">\n\t\t\t\t\t\t\t ';
 } ;
__p += '\n\t\t\t\t\t\t\t ';
 if(!_.isUndefined(search_result.chats)) { ;
__p += '\n\t\t\t\t\t\t\t <li class="list-view"><strong>Matched in 50 chats</strong>\n\t\t\t\t\t\t\t  <div class="panel clearfix">\n\t\t\t\t\t\t\t\t  <ul class="list-inline panel-body">\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1"><a title="#750" href="javascript:void(0)">#750</a></li>\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1"><a title="Card3" href="javascript:void(0)">Card 3</a></li>\n\t\t\t\t\t\t\t\t\t  <li><a title="Votes" href="javascript:void(0)"><i class="icon-thumbs-up"></i><small>0</small></a> </li>\n\t\t\t\t\t\t\t\t\t  <li><span title="Votes"><i class="icon-thumbs-up"></i><small>' +
__e( item.vote_count ) +
'</small></span> </li>\n\t\t\t\t\t\t\t\t\t  <li><a title="Attachments" href="javascript:void(0)"><i class="icon-paper-clip"></i><small>5</small></a> </li>\n\t\t\t\t\t\t\t\t\t  <li><a title="Comments" href="javascript:void(0)"><i class="icon-comment"></i><small>15</small></a></li>\n\t\t\t\t\t\t\t\t\t  <li><a title="Checklists" href="javascript:void(0)"><i class="icon-ok-sign"></i><small>0/2</small></a> </li>\n\t\t\t\t\t\t\t\t\t  <li><a title="Due date" href="javascript:void(0)"><small><span class="label label-default">Feb 10, 2015</span></small></a></li>\n\t\t\t\t\t\t\t\t\t  <li class="col-md-6 pull-right"><p class="htruncate">Lorem Ipsum is simply <span class="bg-search">dummy</span> text of the printing and typesetting industry</p></li>\n\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t<hr class="col-xs-12">\n\t\t\t\t\t\t   ';
 } ;
__p += '\n\t\t\t\t\t\t   ';
 if(!_.isUndefined(search_result.checklists)) { ;
__p += '\n\t\t\t\t\t\t\t <li class="list-view"><strong>Matched in  ' +
__e( search_result.metadata.checklists.count ) +
' Checklists</strong>\n\t\t\t\t\t\t\t   ';
 _.each(search_result.checklists, function(item, key) { ;
__p += ' \n\t\t\t\t\t\t\t    <div class="col-xs-12 panel">\n\t\t\t\t\t\t\t\t   <ul class="list-inline row panel-body js-open-search-model-card-view cur" data-board_id="' +
__e( item.board_id) +
'" data-list_id="' +
__e( item.list_id) +
'" data-card_id="' +
__e( item.id) +
'">\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1"><span title="#' +
__e( item.id ) +
'">#' +
__e( item.id ) +
'</span></li>\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1 htruncate"><span title="' +
__e( item.board_name ) +
'">' +
__e( item.board_name ) +
'</span></li>\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1 htruncate"><span title="' +
__e( item.name ) +
'">' +
__e( item.name ) +
'</span></li>\n\t\t\t\t\t\t\t\t\t  <li><span title="Votes"><i class="icon-thumbs-up"></i><small>' +
__e( item.vote_count ) +
'</small></span> </li>\n\t\t\t\t\t\t\t\t\t  <li><a title="Attachments" href="javascript:void(0)"><i class="icon-paper-clip"></i><small>' +
__e( item.attachment_count ) +
'</small></a> </li>\n\t\t\t\t\t\t\t\t\t   <li><a title="Comments" href="javascript:void(0)"><i class="icon-comment"></i><small>' +
__e( item.attachment_count ) +
'</small></a></li>\n\t\t\t\t\t\t\t\t\t   <li><small><span class="icon-list-ul"></span><span>' +
__e( item.checklist_item_completed_count ) +
'/' +
__e( item.checklist_item_count ) +
'</span></small></li>\n\t\t\t\t\t\t\t\t\t  ';
 if(!_.isUndefined(item.due_date) && item.due_date != null){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t  <li><a title="Due date" href="javascript:void(0)"><small><span class="label label-danger">\n\t\t\t\t\t\t\t\t\t\t  ';

											card_due_date = item.due_date;
											var today = new Date();
											var last_day = new Date(today.getFullYear(), today.getMonth() + 1, 0);
											var next_month_last_day = new Date(today.getFullYear(), today.getMonth() + 2, 0);
											var due_date = new Date(card_due_date);
											var diff = Math.floor(due_date.getTime() - today.getTime());
											var day = 1000 * 60 * 60 * 24;var days = Math.floor(diff / day);
											var months = Math.floor((days + (today.getDate() + 1)) / next_month_last_day.getDate());var years = Math.floor(months / 12);var week = days - (6 - (today.getDay()));
											var label = 'label-default';
											if (years < 0 || months < 0 || days <= -1) {
												label = 'label-danger';
											}
											var date_time = item.due_date.split('T');
											date_time = date_time[0].split(' '); 
										  ;
__p += '\n\t\t\t\t\t\t\t\t\t\t  ' +
((__t = ( dateFormat(date_time[0], "mediumDate") )) == null ? '' : __t) +
'\n\t\t\t\t\t\t\t\t\t\t  </span></small></a></li>\n\t\t\t\t\t\t\t\t\t  ';
 } ;
__p += ' \n\t\t\t\t\t\t\t\t\t  <li class="col-md-6 pull-right">';
 if (!_.isUndefined(item.highlight)) { ;
__p += '<p class="htruncate">' +
((__t = ( item.highlight['cards_checklists.checklist_item_name'] )) == null ? '' : __t) +
'</p>';
 } ;
__p += '</li>\n\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t  ';
 }); ;
__p += '\n\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t ';
							 
							 if (search_result.metadata.checklists.count > 10 && search_result.metadata.checklists.count > ((search_result.metadata.checklists.page > 1)? (parseInt(search_result.metadata.checklists.page) * 20) - 10 : search_result.metadata.checklists.page * 10)) {
							 ;
__p += '\n\t\t\t\t\t\t\t <li class="pull-right js-load-more-search" data-search="' +
__e( search_result.search_term ) +
'" data-page="' +
__e( parseInt(search_result.metadata.checklists.page) + 1 ) +
'" data-for="cards_checklists">\n\t\t\t\t\t\t\t <a href="javascript:void(0)" class="Load More Checklists">Load More Checklists</a>\n\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t ';

							 }
							 ;
__p += '\n\t\t\t\t\t\t\t  <hr class="col-xs-12">\n\t\t\t\t\t\t\t ';
 } ;
__p += '\n\t\t\t\t\t\t\t ';
 if(!_.isUndefined(search_result.cards)) { ;
__p += '\n\t\t\t\t\t\t\t   <li class="list-view"><strong>Matched in ' +
__e( search_result.metadata.cards.count ) +
' cards</strong>\n\t\t\t\t\t\t\t   ';
 _.each(search_result.cards, function(item, key) { ;
__p += ' \n\t\t\t\t\t\t\t\t<div class="col-xs-12 panel">\n\t\t\t\t\t\t\t\t   <ul class="list-inline row panel-body js-open-search-model-card-view cur" data-board_id="' +
__e( item.board_id) +
'" data-list_id="' +
__e( item.list_id) +
'" data-card_id="' +
__e( item.id) +
'">\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1"><span title="#' +
__e( item.id ) +
'">#' +
__e( item.id ) +
'</span></li>\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1 htruncate"><span title="' +
__e( item.board_name ) +
'">' +
__e( item.board_name ) +
'</span></li>\n\t\t\t\t\t\t\t\t\t  <li class="col-md-1 htruncate"><span title="' +
__e( item.name ) +
'">' +
__e( item.name ) +
'</span></li>\n\t\t\t\t\t\t\t\t\t  <li><span title="Votes"><i class="icon-thumbs-up"></i><small>' +
__e( item.vote_count ) +
'</small></span> </li>\n\t\t\t\t\t\t\t\t\t  <li><a title="Attachments" href="javascript:void(0)"><i class="icon-paper-clip"></i><small>' +
__e( item.attachment_count ) +
'</small></a> </li>\n\t\t\t\t\t\t\t\t\t   <li><a title="Comments" href="javascript:void(0)"><i class="icon-comment"></i><small>' +
__e( item.attachment_count ) +
'</small></a></li>\n\t\t\t\t\t\t\t\t\t   <li><small><span class="icon-list-ul"></span><span>' +
__e( item.checklist_item_completed_count ) +
'/' +
__e( item.checklist_item_count ) +
'</span></small></li>\n\t\t\t\t\t\t\t\t\t  ';
 if(!_.isUndefined(item.due_date) && item.due_date != null){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t  <li><a title="Due date" href="javascript:void(0)"><small><span class="label label-danger">\n\t\t\t\t\t\t\t\t\t\t  ';

											card_due_date = item.due_date;
											var today = new Date();
											var last_day = new Date(today.getFullYear(), today.getMonth() + 1, 0);
											var next_month_last_day = new Date(today.getFullYear(), today.getMonth() + 2, 0);
											var due_date = new Date(card_due_date);
											var diff = Math.floor(due_date.getTime() - today.getTime());
											var day = 1000 * 60 * 60 * 24;var days = Math.floor(diff / day);
											var months = Math.floor((days + (today.getDate() + 1)) / next_month_last_day.getDate());var years = Math.floor(months / 12);var week = days - (6 - (today.getDay()));
											var label = 'label-default';
											if (years < 0 || months < 0 || days <= -1) {
												label = 'label-danger';
											}
											var date_time = item.due_date.split('T');
											date_time = date_time[0].split(' '); 
										  ;
__p += '\n\t\t\t\t\t\t\t\t\t\t  ' +
((__t = ( dateFormat(date_time[0], "mediumDate") )) == null ? '' : __t) +
'\n\t\t\t\t\t\t\t\t\t\t  </span></small></a></li>\n\t\t\t\t\t\t\t\t\t  ';
 } ;
__p += ' \n\t\t\t\t\t\t\t\t\t  <li class="col-md-6 pull-right">';
 if (!_.isUndefined(item.highlight)) { ;
__p += '<p class="htruncate">' +
((__t = ( 
									  (!_.isUndefined(item.highlight.description))? item.highlight.description : item.highlight.name )) == null ? '' : __t) +
'</p> ';
 } else if (!_.isUndefined(item.description) && item.description != null) {
									  ;
__p += '\n\t\t\t\t\t\t\t\t\t  <p class="htruncate">' +
((__t = ( 
									  item.description )) == null ? '' : __t) +
'</p>\n\t\t\t\t\t\t\t\t\t  ';

									  } ;
__p += '</li>\n\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t  ';
 }); ;
__p += '  \n\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t ';

							 if (search_result.metadata.cards.count > 10 && search_result.metadata.cards.count > ((search_result.metadata.cards.page > 1)? (parseInt(search_result.metadata.cards.page) * 20) - 10 : search_result.metadata.cards.page * 10)) {
							 ;
__p += '\n\t\t\t\t\t\t\t <li class="pull-right js-load-more-search" data-search="' +
__e( search_result.search_term ) +
'" data-page="' +
__e( parseInt(search_result.metadata.cards.page) + 1 ) +
'" data-for="cards">\n\t\t\t\t\t\t\t <a href="javascript:void(0)" class="Load More Cards">Load More Cards</a>\n\t\t\t\t\t\t\t </li>\n\t\t\t\t\t\t\t ';

							 }
							 ;
__p += '\n\t\t\t\t\t\t\t <hr class="col-xs-12">\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t</ul>\n\t\t\t\t</div>\n\t\t\t  </div>\n\t\t\t\t';
 if(_.isEmpty(search_result)) { ;
__p += '\n\t\t\t\t<div class="well-lg"></div>\n\t\t\t\t<div class="well-lg"></div>\n\t\t\t\t<div class="well-lg"></div>\n\t\t\t\t<div class="text-center text-danger col-sm-6 col-sm-offset-3">No Results Found</div>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t</div>';

}
return __p
};

this["JST"]["templates/search_result"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {


_.each(hits, function(hit) {
	if (hit._index === 'boards') {
;
__p += '\t\n\t\t<li>' +
__e( hit._source.doc.board_name ) +
'</li>\n';
		
	} else if (hit._index === 'lists') {
;
__p += '\t\n\t\t<li>' +
__e( hit._source.doc.list_name ) +
'</li>\n';
		
	} else if (hit._index === 'cards') {
;
__p += '\t\n\t\t<li class="js-show-modal-card-view">' +
__e( hit._source.doc.card_name ) +
'</li>\n';
		
	}

});
;
__p += '\n';

}
return __p
};

this["JST"]["templates/select_board_visibility"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if (name == 'private') {
;
__p += '\n\t\t<span title="Private" class="icon-lock text-primary"></span>' +
__e( i18next.t('Private') ) +
'\t\n';
	} else if (name == 'public') {
;
__p += '\n\t\t<span title="Public" class="icon-circle text-primary"></span>' +
__e( i18next.t('Public') ) +
'\n';
	} else if (!_.isUndefined(data.organization_id)) {
;
__p += '\n\t\t<span title="Organization" class="icon-group text-primary"></span>' +
__e( i18next.t('Organization') ) +
'\n';
	} ;


}
return __p
};

this["JST"]["templates/selected_board_visibility"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<span class="pull-left">\n\t<span class="pull-left navbar-btn">' +
__e( i18next.t('This board will be') ) +
' </span>\n</span>\n<div class="btn-group pull-right">\n\t<button type="button" class="btn btn-default btn-sm js-change-visibility"><i class="icon-lock"></i>';
 if (name == 'org') { ;
__p +=
__e( i18next.t('Organization') ) +
' ';
}else if (name == 'public') { ;
__p +=
__e( i18next.t('Public') ) +
' ';
}else{;
__p +=
__e( i18next.t('Private') );
};
__p += '</button>\n\t<button type="button" class="btn btn-default btn-sm dropdown-toggle js-change-visibility" data-toggle="dropdown" aria-expanded="false">\n\t\t<span>\n\t\t\t<i class="icon-caret-down"></i>\n\t\t</span>\n\t\t<span class="sr-only">' +
__e( i18next.t('Toggle Dropdown') ) +
'</span>\n\t</button>\n</div>';

}
return __p
};

this["JST"]["templates/setting_list"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<!-- Main block start -->\n<section class="clearfix row">\n  <div class="col-xs-12">\n\t<div class="clearfix">\n\t\t<ul class="nav nav-tabs no-bor h3">\n\t\t';
 
			var i = 0;
			if (list.models.length > 0 ) { 
				_.each(list.models, function(settingCategory) {				
					var settings = settingCategory.get('settings');
		;
__p += '\n\t\t\t\t<li ';
 if (!_.isUndefined(id) && id == settingCategory.get('id')) { ;
__p += 'class="active" ';
} else if (_.isUndefined(id) && settingCategory.get('id') == 3) { ;
__p += 'class="active" ';
};
__p += ' ><a href="#/settings/' +
__e(settingCategory.get('id')) +
'">' +
__e( i18next.t(settingCategory.get('name')) ) +
'</a></li>\n\t\t';
 
					i++;
				});
			} 
		;
__p += '\n\t\t</ul>\n\t</div>\n\t<div class="row">\n\t\t<div class="tab-content col-sm-10">\n\t\t';
 if (list.models.length > 0 ) { 
				var j = 0;
				_.each(list.models, function(settingCategory) {				
					var settings = settingCategory.get('settings');
		;
__p += '\t\t\n\t\t\t\t<div class="modal-body tab-pane clearfix ';
 if (!_.isUndefined(id) && id == settingCategory.get('id')) { ;
__p += ' active ';
} else if (_.isUndefined(id) && settingCategory.get('id') == 3) { ;
__p += ' active ';
};
__p += '" id="settingTab' +
__e( settingCategory.get('id') ) +
'">\n\t\t\t\t\t';
 if(!_.isEmpty(settings)){ ;
__p += '\n\t\t\t\t\t';
 if(settingCategory.get('id') == 10){ ;
__p += '\n\t\t\t\t\t<p class="alert alert-info ">' +
__e( i18next.t('To add/reply cards via email you must set up a secret email account with IMAP access. This should support plus addressing and has to be dedicated to handle replying through email feature. Suggested email address is rbreply@yourdomain.tld') ) +
'</p>\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t';
 if(settingCategory.get('id') == 8){ ;
__p += '\n\t\t\t\t\t<p class="alert alert-info ">' +
__e( i18next.t('Different people may use different naming for Todo, Doing and Done. So, it is usually difficult to identify what are actually in Todo, Doing and Done. Below, you can configure how the lists have to be recognized. For a list, you can configure its indicator icon and its color too.') ) +
'</p>\n\t\t\t\t\t<form class="col-md-9 col-xs-12 js-setting-list-form" role="form" id="js-setting-list-form">\n\t\t\t\t\t';
 } else { ;
__p += '\n\t\t\t\t\t<form class="form-horizontal clearfix ';
 if(settingCategory.get('id') == 2){ ;
__p += 'col-lg-8';
 } else { ;
__p += 'col-lg-6';
 } ;
__p += ' col-md-8 col-sm-12 col-xs-12 js-setting-list-form" role="form" id="js-setting-list-form">\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t';

					 var server_detail_fields_count = 0;
					 var connection_detail_fields_count = 0;
					  _.each(settings, function(setting) {  
						  if(setting.setting_category_id == 4 && setting.setting_category_parent_id != 0){
							server_detail_fields_count = server_detail_fields_count + 1;
						  }
						  if(setting.setting_category_id == 5 && setting.setting_category_parent_id != 0){
							connection_detail_fields_count = connection_detail_fields_count + 1;
						  }
					  });
					  ;
__p += '\n\t\t\t\t\t';

					 var prev_category_id = 0;
					 var current_server_detail_fields_count = 0;
					 var current_connection_detail_fields_count = 0;
					  var todo_color = '';
					  var doing_color = '';
					  var done_color = '';
					  var todo_icon = '';
					  var doing_icon = '';
					  var done_icon = '';
					  _.each(settings, function(setting) {  ;
__p += '\n\t\t\t\t\t\t';
 
						  if(setting.name == 'TODO_COLOR') {
							todo_color = setting.type+'__'+setting.id+'__'+setting.name+'__'+setting.value+'__'+setting.label;
							return;
						  }
						  if(setting.name == 'DOING_COLOR') {
							doing_color = setting.type+'__'+setting.id+'__'+setting.name+'__'+setting.value+'__'+setting.label;
							return;
						  }
						  if(setting.name == 'DONE_COLOR') {
							done_color = setting.type+'__'+setting.id+'__'+setting.name+'__'+setting.value+'__'+setting.label;
							return;
						  }
						  if(setting.name == 'TODO_ICON') {
							todo_icon = setting.type+'__'+setting.id+'__'+setting.name+'__'+setting.value+'__'+setting.label;
							return;
						  }
						  if(setting.name == 'DOING_ICON') {
							doing_icon = setting.type+'__'+setting.id+'__'+setting.name+'__'+setting.value+'__'+setting.label;
							return;
						  }
						  if(setting.name == 'DONE_ICON') {
							done_icon = setting.type+'__'+setting.id+'__'+setting.name+'__'+setting.value+'__'+setting.label;
							return;
						  }
						  if(setting.setting_category_id == 4 && setting.setting_category_parent_id != 0){
							current_server_detail_fields_count = current_server_detail_fields_count + 1;
						  }
						  if(setting.setting_category_id == 5 && setting.setting_category_parent_id != 0){
							current_connection_detail_fields_count = current_connection_detail_fields_count + 1;
						  }
							if(setting.setting_category_id != prev_category_id && setting.setting_category_parent_id != 0){ 
							prev_category_id =  setting.setting_category_id;
						;
__p += '\n\t\t\t\t\t\t\t\t';
 if(setting.setting_category_id == 4) { ;
__p += '\n\t\t\t\t\t\t\t\t\t<hr>\n\t\t\t\t\t\t\t\t\t<fieldset>\n\t\t\t\t\t\t\t\t\t\t<legend>\n\t\t\t\t\t\t\t\t\t\t\t<span class="show h4">' +
__e( i18next.t('LDAP configuration') ) +
'</span>\n\t\t\t\t\t\t\t\t\t\t</legend>\n\t\t\t\t\t\t\t\t\t</fieldset>\n\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t';
 if(setting.setting_category_id == 4 || setting.setting_category_id == 5) { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<fieldset>\n\t\t\t\t\t\t\t\t\t\t<div class="col-sm-offset-2">\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t<legend>\n\t\t\t\t\t\t\t\t\t\t\t\t<span class="show h4">' +
((__t = ( i18next.t(setting.category_name) )) == null ? '' : __t) +
'</span>\n\t\t\t\t\t\t\t\t\t\t\t</legend>\t\t\t\t\n\t\t\t\t\t\t\t\t\t';
 if(setting.setting_category_id == 4 || setting.setting_category_id == 5) { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<div class="col-sm-offset-2">\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t';
};
__p += '\n\t\t\t\t\t\t';
 if(setting.type == 'checkbox') { ;
__p += '\n\t\t\t\t\t\t';
 if(setting.id == 22){ ;
__p += '\n\t\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t\t<div class="col-sm-offset-2 col-sm-8 checkbox-inline">\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t<div class="';
 if(setting.name != 'ENABLE_SSL_CONNECTIVITY'){ ;
__p += 'checkbox pull-left';
 } else { ;
__p += 'form-group';
 } ;
__p += '">\n\t\t\t\t\t\t\t\t\t';
 if(setting.name === 'ENABLE_SSL_CONNECTIVITY'){ ;
__p += '<div class="col-xs-3"></div><div\t\tclass="col-xs-9">';
 } ;
__p += '\n \t\t\t\t\t\t\t\t\t\t<input class="js-checkbox" id="inputSetting' +
__e( setting.id ) +
'" name="' +
__e( setting.name ) +
'" type="checkbox" ';
 if(setting.value === 'true') { ;
__p += ' checked="checked" ';
 } ;
__p += ' value="' +
__e( setting.value ) +
'">\n \t\t\t\t\t\t\t\t\t\t<label for="inputSetting' +
__e( setting.id ) +
'">' +
__e( i18next.t(setting.label) ) +
' </label>\n\t\t\t\t\t\t\t\t\t';
 if(setting.name === 'ENABLE_SSL_CONNECTIVITY'){ ;
__p += '</div>';
 } ;
__p += '\n \t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t    ';
 if(setting.id == 3){ ;
__p += '\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t';
 if(setting.id == 31){ ;
__p += '\n\t\t\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t\t  <label for="inputSetting' +
__e( setting.id ) +
'" class="';
 if(settingCategory.get('id') == 2){ ;
__p += 'col-sm-3 ';
 } else { ;
__p += ' col-sm-4 ';
 } ;
__p += ' control-label col-xs-12">' +
__e( i18next.t(setting.label) ) +
'</label>\n\t\t\t\t\t\t\t\t  <div class="';
 if(settingCategory.get('id') == 2){ ;
__p += 'col-sm-9 ';
 } else { ;
__p += ' col-sm-8 ';
 } ;
__p += ' col-xs-12">\n\t\t\t\t\t\t\t\t\t<select name="' +
__e( i18next.t(setting.name) ) +
'" id="inputSetting' +
__e( setting.id ) +
'" class="form-control">\n\t\t\t\t\t\t\t\t\t ';

									 _.each(JSON.parse(window.sessionStorage.getItem('languages')), function(v, k) { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<option ';
 if(k === setting.value) { ;
__p += 'selected ';
 };
__p += ' value="' +
__e( k ) +
'">' +
__e( v ) +
'</option>\n\t\t\t\t\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t\t\t\t\t\t</select>\n\t\t\t\t\t\t\t\t\t<div><span class="help-block">' +
((__t = ( i18next.t(setting.description) )) == null ? '' : __t) +
'</span></div>\n\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t\t  ';
 if(setting.name == 'TODO' || setting.name == 'DOING' || setting.name == 'DONE') { ;
__p += ' \n\t\t\t\t\t\t\t\t  <div class="clearfix">\n\t\t\t\t\t\t\t\t  <label for="inputSetting' +
__e( setting.id ) +
'" class="col-sm-2 control-label text-right">' +
__e( i18next.t(setting.label) ) +
'</label>\n\t\t\t\t\t\t\t\t  <div class=" col-sm-10 col-xs-12">\n\t\t\t\t\t\t\t\t  ';
 } else {;
__p += '\n\t\t\t\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t\t\t  <label for="inputSetting' +
__e( setting.id ) +
'" class="';
 if(settingCategory.get('id') == 2){ ;
__p += 'col-sm-3 ';
 } else { ;
__p += ' col-sm-4 ';
 } ;
__p += ' control-label col-xs-12">' +
__e( i18next.t(setting.label) ) +
'</label>\n\t\t\t\t\t\t\t\t  <div class="';
 if(settingCategory.get('id') == 2){ ;
__p += 'col-sm-9 ';
 } else { ;
__p += ' col-sm-8 ';
 } ;
__p += ' col-xs-12">\n\t\t\t\t\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t\t\t\t\t  ';
 if(setting.type == 'select'){ ;
__p += '\n\t\t\t\t\t\t\t\t\t  <select name="' +
__e( i18next.t(setting.name) ) +
'" id="inputSetting' +
__e( setting.id ) +
'" class="form-control">\n\t\t\t\t\t\t\t\t\t ';
 var options = setting.options.split(',');
									 _.each(options, function(v, k) { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<option ';
 if(v === setting.value) { ;
__p += 'selected ';
 };
__p += ' value="' +
__e( v ) +
'">' +
__e( v ) +
'</option>\n\t\t\t\t\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t\t\t\t\t\t</select>\n\t\t\t\t\t\t\t\t  ';
 } else if(setting.type == 'password') {;
__p += '\n\t\t\t\t\t\t\t\t\t<input type="' +
__e( setting.type ) +
'" id="inputSetting' +
__e( setting.id ) +
'" name="' +
__e( i18next.t(setting.name) ) +
'" class="form-control" />\n\t\t\t\t\t\t\t\t  ';
 } else if(setting.type == 'textarea') {;
__p += '\n\t\t\t\t\t\t\t\t\t';
 if(setting.name == 'TODO') { 
										todo_color = todo_color.split('__');
										todo_icon = todo_icon.split('__');
									;
__p += '\n\t\t\t\t\t\t\t\t\t\t<div class="col-sm-4 form-group">\n\t\t\t\t\t\t\t\t\t\t<input type="' +
__e( todo_icon[0] ) +
'" id="inputSetting' +
__e( todo_icon[1] ) +
'" name="' +
__e( i18next.t(todo_icon[2]) ) +
'" class="form-control" value="' +
__e( todo_icon[3] ) +
'" placeholder="' +
__e( todo_icon[4] ) +
'" />\n\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t\t<div class="col-sm-4 form-group clearfix">\n\t\t\t\t\t\t\t\t\t\t<input type="' +
__e( todo_color[0] ) +
'" id="inputSetting' +
__e( todo_color[1] ) +
'" name="' +
__e( i18next.t(todo_color[2]) ) +
'" class="form-control pull-left" value="' +
__e( todo_color[3] ) +
'" placeholder="' +
__e( todo_color[4] ) +
'" />\n\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t';
 if(setting.name == 'DOING') { 
										doing_color = doing_color.split('__');
										doing_icon = doing_icon.split('__');
									;
__p += '\t\n\t\t\t\t\t\t\t\t\t\t<div class="col-sm-4 form-group">\n\t\t\t\t\t\t\t\t\t\t<input type="' +
__e( doing_icon[0] ) +
'" id="inputSetting' +
__e( doing_icon[1] ) +
'" name="' +
__e( i18next.t(doing_icon[2]) ) +
'" class="form-control" value="' +
__e( doing_icon[3] ) +
'" placeholder="' +
__e( doing_icon[4] ) +
'" />\n\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t\t<div class="col-sm-4 form-group clearfix">\n\t\t\t\t\t\t\t\t\t\t<input type="' +
__e( doing_color[0] ) +
'" id="inputSetting' +
__e( doing_color[1] ) +
'" name="' +
__e( i18next.t(doing_color[2]) ) +
'" class="form-control pull-left" value="' +
__e( doing_color[3] ) +
'" placeholder="' +
__e( doing_color[4] ) +
'" />\n\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t';
 if(setting.name == 'DONE') { 
										done_color = done_color.split('__');
										done_icon = done_icon.split('__');
									;
__p += '\n\t\t\t\t\t\t\t\t\t\t<div class="col-sm-4 form-group">\n\t\t\t\t\t\t\t\t\t\t<input type="' +
__e( done_icon[0] ) +
'" id="inputSetting' +
__e( done_icon[1] ) +
'" name="' +
__e( i18next.t(done_icon[2]) ) +
'" class="form-control" value="' +
__e( done_icon[3] ) +
'" placeholder="' +
__e( done_icon[4] ) +
'"/>\n\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t\t<div class="col-sm-4 form-group clearfix">\n\t\t\t\t\t\t\t\t\t\t<input type="' +
__e( done_color[0] ) +
'" id="inputSetting' +
__e( done_color[1] ) +
'" name="' +
__e( i18next.t(done_color[2]) ) +
'" class="form-control pull-left" value="' +
__e( done_color[3] ) +
'" placeholder="' +
__e( done_color[4] ) +
'"/>\n\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t';
 if(setting.name == 'TODO' || setting.name == 'DOING' || setting.name == 'DONE') { ;
__p += ' \n\t\t\t\t\t\t\t\t\t<div class="col-sm-4 form-group">\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t<textarea id="inputSetting' +
__e( setting.id ) +
'" name="' +
__e( i18next.t(setting.name) ) +
'" class="form-control" >' +
__e( setting.value ) +
'</textarea>\n\t\t\t\t\t\t\t\t\t';
 if(setting.name == 'TODO' || setting.name == 'DOING' || setting.name == 'DONE') { ;
__p += ' \n\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t  ';
 } else { ;
__p += '\n\t\t\t\t\t\t\t\t\t<input type="' +
__e( setting.type ) +
'" id="inputSetting' +
__e( setting.id ) +
'" name="' +
__e( i18next.t(setting.name) ) +
'" class="form-control" value="' +
__e( setting.value ) +
'" />\n\t\t\t\t\t\t\t\t  ';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t<div><span class="help-block">' +
((__t = ( i18next.t(setting.description) )) == null ? '' : __t) +
'</span></div>\n\t\t\t\t\t\t\t\t  </div>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t';
 
							if((setting.setting_category_id == 4 || setting.setting_category_id == 5) && (current_server_detail_fields_count == server_detail_fields_count || current_connection_detail_fields_count == connection_detail_fields_count)){ 
							server_detail_fields_count = 0;
							connection_detail_fields_count = 0;
						;
__p += '\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</fieldset>\t\t\n\t\t\t\t\t\t';
};
__p += '\n\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t\t';
 if(settingCategory.get('id') == 8){ ;
__p += '\n\t\t\t\t\t  <div class="form-group">\n\t\t\t\t\t\t<label for="submit2" class="col-sm-2 control-label"></label>\n\t\t\t\t\t\t<div class="col-sm-8">\n\t\t\t\t\t\t<input type="submit" value="' +
__e( i18next.t('Submit') ) +
'" id="submit2" class="btn btn-primary">\n\t\t\t\t\t\t</div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t ';
 } else { ;
__p += ' \n\t\t\t\t\t <div class="form-group">\n\t\t\t\t\t\t<label for="submit2" class="sr-only ';
 if(settingCategory.get('id') == 2){ ;
__p += 'col-sm-3 ';
 } else { ;
__p += ' col-sm-4 ';
 } ;
__p += ' control-label col-xs-12">' +
__e( i18next.t('Submit') ) +
'</label>\n\t\t\t\t\t\t<div class="col-sm-8">\n\t\t\t\t\t\t<input type="submit" value="' +
__e( i18next.t('Submit') ) +
'" id="submit2" class="btn btn-primary">\n\t\t\t\t\t\t</div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t ';
 } ;
__p += ' \n\t\t\t\t\t</form>\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t</div>\n\t\t';
 j++; ;
__p += '\n\t\t';
 if(settingCategory.id == 2 && id == 2){ ;
__p += '\n\t\t\t<legend>\n\t\t\t\t<span class="show h4">' +
__e( i18next.t('Import LDAP users') ) +
'</span>\n\t\t\t</legend>\n\t\t\t<div class="form-group">\n\t\t\t\t<div class="col-xs-3"></div><div class="col-xs-9">\n\t\t\t\t\t<input type="checkbox" value="" name="enableImportUsers" id="enableImportUsers" class="js-enable-import-user">\n\t\t\t\t\t<label for="enableImportUsers">' +
__e( i18next.t('Import Groups from LDAP into Organizations and put users under organization. If this option is unchecked, only the users will be imported (not organization)') ) +
' </label>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="form-group">\n\t\t\t\t<div class="col-xs-3"></div><div class="col-xs-9">\n\t\t\t\t\t<input type="checkbox" value="" name="dontSendWelcomeMail" id="dontSendWelcomeMail">\n\t\t\t\t\t<label for="dontSendWelcomeMail">' +
__e( i18next.t("Don't send welcome email") ) +
' </label>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="form-group">\n\t\t\t\t<label for="enableImportUsersSubmit" class="sr-only col-sm-4 control-label col-xs-12">' +
__e( i18next.t('Import users') ) +
'</label>\n\t\t\t\t<div class="col-sm-8">\n\t\t\t\t<button type="button" id="importUsersSubmit" class="js-import-users btn btn-primary">' +
__e( i18next.t('Import users') ) +
'</button>\n\t\t\t\t<span class="clearfix hide" id="js-loader-img"><span class="cssloader"></span></span>\n\t\t\t\t</div>\n\t\t    </div>\n\t\t';
 } ;
__p += '\n\t\t';
 });
			} 
		;
__p += '\t\n\t\t</div>\n\t</div>\n  </div>\n</section>\n<!-- Main block end -->';

}
return __p
};

this["JST"]["templates/show_all_visibility"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {


	var private_visibility = "";
	var org_visibility = "";
	var public_visibility = "";
	
	if (visibility == 0) {
		private_visibility = '<i class="icon-check"></i>';
	} else if (visibility == 1) {
		org_visibility = '<i class="icon-check"></i>';
	} else if (visibility == 2) {
		public_visibility = '<i class="icon-check"></i>';
	}
;
__p += '\n\t<li class="col-xs-12 btn-block">\n\t\t<a href="#" name="private" class="';
  if (visibility == 0) { ;
__p += ' btn-default ';
 } ;
__p += ' js-select h6 navbar-btn"> \n\t\t\t<span class="show text-primary navbar-btn h5"> ' +
((__t = ( i18next.t('Private %s', { postProcess: 'sprintf', sprintf: [private_visibility]}) )) == null ? '' : __t) +
' </span>\n\t\t\t<span class="show"> ' +
__e( i18next.t('This board is private. Only people added to the board can view and edit it.') ) +
' </span>\n\t\t</a>\n\t</li>\n\t<li class="col-xs-12 divider navbar-btn"> </li>\n\t<li class="col-xs-12 btn-block"> \n\t\t<a href="#" name="org" class="';
  if (visibility == 1) { ;
__p += ' btn-default ';
 } ;
__p += ' js-select js-show-add-organization-form h6 navbar-btn">\n\t\t\t<span class="show text-primary navbar-btn h5"> ' +
((__t = ( i18next.t('Organization %s', { postProcess: 'sprintf', sprintf: [org_visibility]}) )) == null ? '' : __t) +
' </span>\n\t\t\t<span class="show"> ' +
__e( i18next.t('This board is visible to members of the organization. Only people added to the board can edit.') ) +
' <span class="error"> ' +
__e( i18next.t('The board must be added to an org to enable this.') ) +
' </span> </span> </a>\n\t</li>\n\t<li class="col-xs-12 divider navbar-btn"> </li>\n\t<li class="col-xs-12 btn-block"> \n\t\t<a href="#" name="public" class="';
  if (visibility == 2) { ;
__p += ' btn-default ';
 } ;
__p += ' js-select h6 navbar-btn"><span class="show text-primary navbar-btn h5"> ' +
((__t = ( i18next.t('Public %s', { postProcess: 'sprintf', sprintf: [public_visibility]}) )) == null ? '' : __t) +
' </span><span class="show"> ' +
__e( i18next.t("This board is public. It's visible to anyone with the link and will show up in search engines like Google. Only people added to the board can edit.") ) +
'  </span> </a> \n\t</li>';

}
return __p
};

this["JST"]["templates/show_board_member_permission_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="col-xs-12 text-center clearfix">\n\t<span class="col-xs-10"><strong>' +
__e( i18next.t('Change permissions') ) +
'</strong></span><a class="js-close-popover pull-right" href="#"><i class="icon-remove"></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12 member-modal js-pre-scrollable vertical-scrollbar">\n\t<ul class="list-unstyled list-inline">\n\t\t<li class="plull-left">\n\t\t\t<a class="js-edit-board-member-permission-to-admin" data-board_user_id="' +
__e( board_user_id ) +
'" href="#">\n\t\t\t\t<span class="show">' +
__e( i18next.t('Admin') ) +
'</span><span>' +
__e( i18next.t('Can view, create and edit boards, and change settings for the board.') ) +
'</span>\n\t\t\t</a>\n\t\t</li>\n\t\t<li class="plull-left">\n\t\t\t<a class="js-edit-board-member-permission-to-normal" data-board_user_id="' +
__e( board_user_id ) +
'" href="#">\n\t\t\t\t<span class="show">' +
__e( i18next.t('Normal') ) +
'</span><span>' +
__e( i18next.t('Can view, create, and view members, but not change settings.') ) +
'</span>\n\t\t\t</a>\n\t\t</li>\n\t</ul>\n</div>';

}
return __p
};

this["JST"]["templates/show_board_visibility"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '        <li class="col-xs-12 btn-block"><a href="#" name="private" class="';
  if (visibility == 0) { ;
__p += ' btn-default ';
 } ;
__p += '  h6 js-set-privte-board navbar-btn"> <span class="show text-primary navbar-btn h5"> ' +
__e( i18next.t('Private') ) +
' ';
 if (visibility == 0) { ;
__p += ' <i class="icon-check"></i> ';
 } ;
__p += ' </span><span class="show"> ' +
__e( i18next.t('This board is private. Only people added to the board can view and edit it.') ) +
' </span> </a> </li>\n\t\t<li class="divider col-xs-12 navbar-btn"></li>\n        <li class="col-xs-12 btn-block"> <a href="#" name="org" class="';
  if (visibility == 1) { ;
__p += ' btn-default ';
 } ;
__p += ' h6 navbar-btn js-show-board-organization"><span class="show text-primary navbar-btn h5"> ' +
__e( i18next.t('Organization') ) +
' ';
 if (visibility == 1) { ;
__p += ' <i class="icon-check"></i> ';
 } ;
__p += ' </span><span class="show"> ' +
__e( i18next.t('This board is visible to members of the organization. Only people added to the board can edit.') ) +
' <span class="error"> ' +
__e( i18next.t('The board must be added to an org to enable this.') ) +
' </span> </span> </a> </li>\n\t\t<li class="divider col-xs-12 navbar-btn"></li> \n        <li class="col-xs-12 btn-block"> <a href="#" name="public" class="';
  if (visibility == 2) { ;
__p += ' btn-default ';
 } ;
__p += ' h6 navbar-btn js-set-public-board"><span class="show text-primary navbar-btn h5"> ' +
__e( i18next.t('Public') ) +
' ';
  if (visibility == 2) { ;
__p += ' <i class="icon-check"></i> ';
 } ;
__p += ' </span><span class="show"> ' +
__e( i18next.t("This board is public. It's visible to anyone with the link and will show up in search engines like Google. Only people added to the board can edit.") ) +
'  </span> </a> </li>';

}
return __p
};

this["JST"]["templates/show_copy_board"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="clearfix">\n<div class="clearfix text-center col-xs-12">\n\t<a href="#" class="js-back-to-sidebar pull-left btn btn-xs btn-link">\n\t\t<i class="icon-caret-left"></i>\n\t</a>\n\t<span class="col-xs-10 navbar-btn"><strong>' +
__e( i18next.t("Copy board") ) +
'</strong></span>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n<form class="normal" name="BoardCopyForm" id="BoardCopyForm" method="POST">\n  <fieldset>\n  <div class="form-group required">\n\t<label for="inputCopyBoardName">' +
__e( i18next.t("Name") ) +
'</label>\n\t<input type="text" autocomplete="off" id="inputCopyBoardName" name="name" class="form-control input-sm" required>\n  </div>\n  <input name="board_visibility"  id="inputBoardCopyVisibility" type="hidden" value="' +
__e(board.attributes.board_visibility ) +
'">\n  <div id="js-board-add-organization"></div>\n\t<div class="clearfix js-open-dropdown js-board-add-dropdown dropdown js-visibility-chooser-copy-board-dropdown"> \n\t\t<span class="js-visibility-container">\n\t\t\t<span class="pull-left">\n\t\t\t\t<span class="pull-left navbar-btn">' +
__e( i18next.t("This board will be") ) +
' </span>\n\t\t\t</span>\n\t\t\t<div class="btn-group pull-right"> \n\t\t\t\t<button type="button" class="btn btn-default btn-sm js-change-visibility" id="js-change-visible-content">';
 if(board.attributes.board_visibility == 0) { ;
__p += '\n\t\t\t\t\t<i class="icon-lock"></i>' +
__e( i18next.t("Private") ) +
'\n\t\t\t\t';
 } else if(board.attributes.board_visibility == 1) { ;
__p += '\n\t\t\t\t\t<i class="icon-group"></i>' +
__e( i18next.t("Organization") ) +
'\n\t\t\t\t';
 } else if(board.attributes.board_visibility == 2) { ;
__p += '\n\t\t\t\t\t<i class="icon-circle"></i>' +
__e( i18next.t("Public") ) +
'\n\t\t\t\t';
 } ;
__p += '</button>\n\t\t\t\t<button type="button" class="btn btn-default btn-sm dropdown-toggle js-change-visibility" data-toggle="dropdown" aria-expanded="false">\n\t\t\t\t\t<span><i class="icon-caret-down"></i></span>\n\t\t\t\t\t<span class="sr-only">' +
__e( i18next.t("Toggle Dropdown") ) +
'</span>\n\t\t\t\t</button>\n\t\t\t</div>\n\t\t</span>\n\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t<li class="text-center">\n\t\t\t\t<strong>' +
__e( i18next.t("Change Visibility") ) +
'</strong>\n\t\t\t\t<span href="#" class="js-close-sidebar-popover pull-right col-xs-2"><i class="icon-remove cur"></i></span>\n\t\t\t</li>\n\t\t\t<li class="col-xs-12 divider js-visibility-chooser-copy-board"></li>\n\t\t</ul>\n\t</div>\n  <div class="form-group">\n\t<div class="checkbox">\n\t\t<input id="inputKeepCards" type="checkbox" checked="checked" value="1" name="keepCards" class="hide">\n\t\t<label for="inputKeepCards">' +
__e( i18next.t("Keep Cards") ) +
'</label>\n\t</div>\n  </div>\n  <div class="submit">\n\t<input type="submit" value="' +
__e( i18next.t('Create') ) +
'" id="submitBoardCopy" class="btn btn-primary">\n  </div>\n  </fieldset>\n</form>\n</div>\n</div>';

}
return __p
};

this["JST"]["templates/show_search_boards"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(!_.isEmpty(board) && board != null){ ;
__p += '\n\t<a class="clearfix" href="#/board/' +
__e( board.attributes.id ) +
'">\n\t\t<span style="' +
((__t = ( style )) == null ? '' : __t) +
'" class="preview-thumbnail"></span>\n\t\t<span class="fade"></span>\n\t\t<span class="details">\n\t\t\t<span title="' +
__e( board.attributes.name ) +
'" class="board-list-item-name htruncate col-xs-12 row">' +
__e( board.attributes.name ) +
'</span>\n\t\t\t<span class="pull-right hide js-stared-conatiner js-stared-conatiner-' +
__e( board.attributes.id ) +
'">\n\t\t\t\t<span  title="' +
__e( i18next.t('Click to star this board. It will show up at top of your boards list.') ) +
'" name="subscribe" class="icon-star-empty js-star-board" data-board_id="' +
__e( board.attributes.id ) +
'">\t\t</span>\n\t\t\t</span>\n\t\t</span>\n\t</a>\n';
 } else{ ;
__p += '\n\t<span class="col-xs-12"><div class="alert alert-info">\n\t' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('boards')] }) ) +
'\n</div></span>\n';
 } ;


}
return __p
};

this["JST"]["templates/show_search_message"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p +=
__e( i18next.t("You can use search operators like @member, #label, is:archived, and has:attachments to refine your search.") );

}
return __p
};

this["JST"]["templates/show_sync_google_calendar"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix">\n\t<div class="clearfix col-xs-12">\n\t\t<a href="#" class="js-back-to-sidebar pull-left btn btn-xs btn-link">\n\t\t\t<i class="icon-caret-left"></i>\n\t\t</a>\n\t\t<span class="col-xs-10 navbar-btn"><strong>' +
__e( i18next.t("iCal Feed") ) +
'</strong></span>\n\t</div>\n\t<div class="col-xs-12 divider"></div>\n\t<div class="col-xs-12">\n\t\t<form class="normal col-xs-12">\n\t\t  <div class="form-group">\n\t\t\t<label>' +
__e( i18next.t('iCal Feed URL') ) +
'</label>\n\t\t\t<input type="text" readonly="readonly" value="" class="form-control input-sm js-syn-calendar-response" id="js-select-google-sync-url">\n\t\t\t<p>\n\t\t\t\t' +
((__t = ( i18next.t('Sync with Google Calendar: To add iCal feed URL in Google calendar please refer, %s', { postProcess: 'sprintf', sprintf: ['<a class="text-wrap" href="https://support.google.com/calendar/answer/37100" target="_blank">https://support.google.com/calendar/answer/37100</a>']}) )) == null ? '' : __t) +
'\n\t\t\t</p>\n\t\t\t<p>\n\t\t\t\t' +
__e( i18next.t("NOTE: Changes made in Restyaboard won't instantly update to Google Calendar. We estimate that Google Calendar update their external feeds approximately once per day, but that is dependent on Google Calendar.") ) +
'\n\t\t\t</p>\n\t\t  </div>\n\t\t</form>\n\t</div>\n</div>';

}
return __p
};

this["JST"]["templates/starred_boards_index"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '  ';
 if(!_.isEmpty(role_links.where({slug: "view_stared_boards"}))){ ;
__p += '\n  <div class="btn-block clearfix">\n    <div class="col-xs-12 js-header-starred-boards">\n\t  <hr>\n    </div>\n  </div>\n  ';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/started_boards_listing"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(board != null){		
	var style = '';					
	if (board.attributes.background_picture_url) {
		var background_picture_url = board.attributes.background_picture_url.replace("_XXXX.jpg", "_s.jpg");
		style = 'background-image:url(' + background_picture_url + '); background-size:cover;';
	} else if (board.attributes.background_pattern_url) {
		var background_pattern_url = board.attributes.background_pattern_url.replace("_XXXX.jpg", "_s.jpg");
		style = 'background-image:url(' + background_pattern_url + '); background-size:cover;';
	} else if (board.attributes.background_color){
		style = 'background-color:' + board.attributes.background_color + ';color:#ffffff;';
	} else {
		style = '';
	}
;
__p += '\n\t\t\t\t\n<a href="#/board/' +
__e( board.attributes.id ) +
'" class="highlight-icon clearfix">\n\t<span style="' +
((__t = ( style )) == null ? '' : __t) +
'" class="preview-thumbnail"></span>\n\t<span class="details navbar-btn">\n\t\t<span title="' +
__e( board.attributes.name ) +
'" class="board-list-item-name navbar-btn">' +
__e( board.attributes.name ) +
'</span>\n\t\t<span class="pull-right hide js-stared-conatiner js-stared-conatiner-' +
__e( board.attributes.board_id ) +
'"></span>  \n\t</span> \n</a>\n';
 }else{ ;
__p += '\n <div class="alert alert-info">\n\t' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('boards')] }) ) +
'\n</div>\n';
};


}
return __p
};

this["JST"]["templates/subscribe_board_confirm"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\t\n\t<a href="#" class="js-back-to-sidebar pull-left"><i class="icon-caret-left "></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t("Subscribe") ) +
'</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove "></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<p>' +
__e( i18next.t("While subscribe, we will send email notification about each activities in this board.") ) +
'</p>\t\n\t<a class="js-subscribe-board btn  btn-primary" title="' +
__e( i18next.t('Subscribe') ) +
'">' +
__e( i18next.t("Subscribe") ) +
'</a>\n</div>';

}
return __p
};

this["JST"]["templates/switch_to_list_form"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<thead>\n\t<tr>\n\t\t<th>\n\t\t\t<ul class="list-inline navbar-btn clearfix">\t\n\t\t\t\t<li class="col-md-1 col-xs-2"><a class="js-sort-by show" title="' +
__e( i18next.t('ID') ) +
'" href="#" data-sort-by="id"><span class="icon-caret-down"></span>' +
__e( i18next.t("ID") ) +
'</a></li>\n\t\t\t\t<li class="col-md-4 col-xs-3"><a class="js-sort-by show" title="' +
__e( i18next.t('Card Name') ) +
'" href="#" data-sort-by="name"><span class="icon-caret-down hide"></span>' +
__e( i18next.t("Card Name") ) +
'</a></li>\n\t\t\t\t<li class="col-md-4 col-xs-3"><a class="js-sort-by show" title="' +
__e( i18next.t('List Name') ) +
'" href="#" data-sort-by="list_name"><span class="icon-caret-down hide"></span>' +
__e( i18next.t("List Name") ) +
'</a></li>\n\t\t\t\t<li class="list-head-icon">\n\t\t\t\t\t<ul class="list-inline row">\n\t\t\t\t\t\t<li><a class="show" href="#" title="' +
__e( i18next.t('Votes') ) +
'" ><span class="icon-caret-down hide"></span><i  data-sort-by="card_voter_count" class="js-sort-by icon-thumbs-up h3"></i></a></li> \n\t\t\t\t\t\t<li><a class="show" href="#" title="' +
__e( i18next.t('Attachments') ) +
'" ><span class="icon-caret-down hide"></span><i data-sort-by="attachment_count" class="js-sort-by icon-paper-clip h3"></i></a></li>\n\t\t\t\t\t\t<li><a class="show" href="#" title="' +
__e( i18next.t('Comments') ) +
'"><span class="icon-caret-down hide"></span><i data-sort-by="comment_count" class="js-sort-by icon-comment h3"></i></a></li>\n\t\t\t\t\t\t<li><a class="show" href="#" title="' +
__e( i18next.t('Checklist') ) +
'" ><span class="icon-caret-down hide"></span><i  data-sort-by="checklist_item_completed_count" class="js-sort-by icon-ok-sign h3"></i></a></li>\n\t\t\t\t\t\t<li><a class="show" href="#" title="' +
__e( i18next.t('Due date') ) +
'" ><span class="icon-caret-down hide"></span><i data-sort-by="due_date" class="js-sort-by icon-calendar h3"></i></a></li>\n\t\t\t\t\t</ul>  \n\t\t\t\t</li>\n            </ul>\n\t\t</th>\n\t<tr>\n</thead>\n<tbody class="js-card-list-view-' +
__e( board.id) +
'"></tbody>\n\n';

}
return __p
};

this["JST"]["templates/unsubscribe_board_confirm"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="clearfix text-center col-xs-12">\t\n\t<a href="#" class="js-back-to-sidebar pull-left"><i class="icon-caret-left "></i></a><span class="col-xs-10"><strong>' +
__e( i18next.t("Unsubscribe") ) +
'</strong></span><a class="js-close-popup pull-right" href="#"><i class="icon-remove "></i></a>\n</div>\n<div class="col-xs-12 divider"></div>\n<div class="col-xs-12">\n\t<p>' +
__e( i18next.t("While unsubscribe, we will not send any email notification for this board.") ) +
'</p>\t\n\t<a class="js-unsubscribe-board btn  btn-primary" title="' +
__e( i18next.t('Unsubscribe') ) +
'">' +
__e( i18next.t("Unsubscribe") ) +
'</a>\n</div>';

}
return __p
};

this["JST"]["templates/user"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<td>\n    <div class="form-group text-center">\n\t    <div class="checkbox">\n            <input ';
 if(user.attributes.role_id == 1){;
__p += 'disabled';
};
__p += ' id="' +
__e( user.attributes.id) +
'"  name="user_id[' +
__e( user.attributes.id ) +
']" value="' +
__e( user.attributes.id) +
'" class="js-checkbox-list ';
if(parseInt(user.attributes.is_active) === 1){;
__p += 'js-checkbox-active';
}else{;
__p += 'js-checkbox-inactive';
};
__p += '" type="checkbox">\n            <label class="js-update-user" data-user_id="' +
__e( user.attributes.id ) +
'" for="' +
__e( user.attributes.id) +
'"></label>\n        </div>\n    </div>\n</td>\n<td>\n<div class="clearfix"> \n\t<a  title="' +
__e( user.attributes.full_name) +
' (' +
__e( user.attributes.username) +
')" class="small-user pull-left show" href="#/user/' +
__e( user.attributes.id) +
'">\n\t\t';
 if(!_.isEmpty(user.attributes.profile_picture_path)){ 
		    var profile_picture_path = user.showImage('User', user.attributes.id, 'small_thumb' );
	    ;
__p += '\n\t\t\t<img class="avatar-sm" src="' +
__e( profile_picture_path) +
'" alt="[Images: ' +
__e( user.attributes.username) +
']" title="' +
__e( user.attributes.full_name ) +
' (' +
__e( user.attributes.username) +
')" />\n\t\t\t';
 }else{ ;
__p += '\n\t\t\t\t\t<i class="avatar avatar-color-194 img-rounded avatar-sm" title="' +
__e( user.attributes.full_name) +
' (' +
__e( user.attributes.username) +
')">' +
__e( user.attributes.initials) +
'</i>\n\t\t\t  ';
  } ;
__p += ' \n    </a>\n   <a class="col-xs-7 htruncate" href="#/user/' +
__e( user.attributes.id) +
'">' +
__e( user.attributes.full_name) +
'</a><a>';
 if(!user.attributes.is_email_confirmed){ ;
__p += '\n\t\t\t<span class="label label-warning navbar-right">' +
__e( i18next.t('Unconfirmed') ) +
'</span>\n\t\t';
 } ;
__p += ' \n\t';
 if(user.attributes.is_ldap){ ;
__p += '\n\t\t\t<span class="label label-success navbar-right">LDAP</span>\n\t\t';
 } ;
__p += '\n\t\t</a>\n\t\t\n</div>\n<div class="clearfix navbar-btn">\n\t<span class="col-xs-12 htruncate nav">' +
__e( user.attributes.email) +
'</span>\n</div>\n</td> \n<td class="text-center">\n\t<div class="btn-group text-left navbar-btn dropdown">\n\t    <a title="Organizations" class="btn btn-default btn-xs ';
 if(user.attributes.created_organization_count != 0){ ;
__p += 'dropdown-toggle';
}else{;
__p += 'js-no-action';
};
__p += '"\n\t\t';
 if(user.attributes.created_organization_count != 0){ ;
__p += 'href="#"';
}else{;
__p += 'href="#/users"';
};
__p += '\n\t\t';
 if(user.attributes.created_organization_count != 0){ ;
__p += 'data-toggle="dropdown"';
};
__p += '>' +
__e( user.attributes.created_organization_count) +
'</a>\n\t\t\t';
 if(user.attributes.created_organization_count != 0){ ;
__p += '\n\t\t\t\t<ul class="dropdown-menu arrow arrow-left  text-left" role="boards">\n\t\t\t\t\t';
 _.each(user.attributes.organizations, function(organization){;
__p += '\n\t\t\t\t\t\t<li><a href="#/organization/' +
__e(organization.id) +
'">' +
__e(organization.name) +
'</a></li>\n\t\t\t\t\t';
});
__p += '\n\t\t\t\t</ul>\n\t\t\t';
};
__p += '\n\t\t\t';
 if(user.attributes.created_organization_count == 0){ ;
__p += '\n\t\t\t\t<ul class="dropdown-menu arrow arrow-left  text-left" role="boards">\n\t\t\t\t\t';
 _.each(user.attributes.organizations, function(organization){;
__p += '\n\t\t\t\t\t\t<li>a href="#/organization/' +
__e(organization.id) +
'">' +
__e(organization.name) +
'</a></a></li>\n\t\t\t\t\t';
});
__p += '\n\t\t\t\t</ul>\n\t\t\t';
};
__p += '\n    </div>\n</td>\n<td class="text-center">\n    <div class="btn-group text-left navbar-btn dropdown">\n\t    <a title="' +
__e( i18next.t('Organizations') ) +
'" class="btn btn-default btn-xs ';
 if(user.attributes.owner_organization_count != 0){ ;
__p += 'dropdown-toggle';
}else{;
__p += 'js-no-action';
};
__p += '"\n\t\t';
 if(user.attributes.owner_organization_count != 0){ ;
__p += 'href="#"';
}else{;
__p += 'href="#/users"';
};
__p += '\n\t\t';
 if(user.attributes.owner_organization_count != 0){ ;
__p += 'data-toggle="dropdown"';
};
__p += '>' +
__e( user.attributes.owner_organization_count) +
'</a>\n\t\t\t';
 if(user.attributes.owner_organization_count != 0){ ;
__p += '\n\t\t\t\t<ul class="dropdown-menu arrow arrow-left  text-left" role="boards">\n\t\t\t\t\t';
 _.each(user.attributes.organizations, function(organization){;
__p += '\n\t\t\t\t\t\t<li><a href="#/organization/' +
__e(organization.id) +
'">' +
__e(organization.name) +
'</a></li>\n\t\t\t\t\t';
});
__p += '\n\t\t\t\t</ul>\n\t\t\t';
};
__p += '\n\t\t\t';
 if(user.attributes.owner_organization_count == 0){ ;
__p += '\n\t\t\t\t<ul class="dropdown-menu arrow arrow-left  text-left" role="boards">\n\t\t\t\t\t';
 _.each(user.attributes.organizations, function(organization){;
__p += '\n\t\t\t\t\t\t<li>a href="#/organization/' +
__e(organization.id) +
'">' +
__e(organization.name) +
'</a></a></li>\n\t\t\t\t\t';
});
__p += '\n\t\t\t\t</ul>\n\t\t\t';
};
__p += '\n    </div>\n</td>\n<td class="text-center">\n    <div class="btn-group text-left navbar-btn dropdown">\n\t    <a title="' +
__e( i18next.t('Organizations') ) +
'" class="btn btn-default btn-xs ';
 if(user.attributes.member_organization_count != 0){ ;
__p += 'dropdown-toggle';
}else{;
__p += 'js-no-action';
};
__p += '"\n\t\t';
 if(user.attributes.member_organization_count != 0){ ;
__p += 'href="#"';
}else{;
__p += 'href="#/users"';
};
__p += '\n\t\t';
 if(user.attributes.member_organization_count != 0){ ;
__p += 'data-toggle="dropdown"';
};
__p += '>' +
__e( user.attributes.member_organization_count) +
'</a>\n\t\t\t';
 if(user.attributes.member_organization_count != 0){ ;
__p += '\n\t\t\t\t<ul class="dropdown-menu arrow arrow-left  text-left" role="boards">\n\t\t\t\t\t';
 _.each(user.attributes.organizations, function(organization){;
__p += '\n\t\t\t\t\t\t<li><a href="#/organization/' +
__e(organization.id) +
'">' +
__e(organization.name) +
'</a></li>\n\t\t\t\t\t';
});
__p += '\n\t\t\t\t</ul>\n\t\t\t';
};
__p += '\n\t\t\t';
 if(user.attributes.member_organization_count == 0){ ;
__p += '\n\t\t\t\t<ul class="dropdown-menu arrow arrow-left  text-left" role="boards">\n\t\t\t\t\t';
 _.each(user.attributes.organizations, function(organization){;
__p += '\n\t\t\t\t\t\t<li>a href="#/organization/' +
__e(organization.id) +
'">' +
__e(organization.name) +
'</a></a></li>\n\t\t\t\t\t';
});
__p += '\n\t\t\t\t</ul>\n\t\t\t';
};
__p += '\n    </div>\n</td>\n<td class="text-center"> \n   <div class="btn-group text-left navbar-btn dropdown">\n\t\t<a title="' +
__e( i18next.t('Boards') ) +
'" class="btn btn-default btn-xs ';
 if(user.attributes.created_board_count != 0){ ;
__p += 'dropdown-toggle';
}else{;
__p += 'js-no-action';
};
__p += '"\n\t\t';
 if(user.attributes.created_board_count != 0){ ;
__p += 'href="#"';
}else{;
__p += 'href="#/users"';
};
__p += '\n\t\t';
 if(user.attributes.created_board_count != 0){ ;
__p += 'data-toggle="dropdown"';
};
__p += '>' +
__e( user.attributes.created_board_count) +
'</a>\n\t\t\t';
 if(user.attributes.created_board_count != 0){ ;
__p += '\n\t\t\t\t<ul class="dropdown-menu arrow arrow-left  text-left" role="boards" id="js-user-activity-menu-response-' +
__e( user.attributes.id) +
'">\n\t\t\t\t</ul>\n\t\t   ';
};
__p += '\n\t</div>\n</td>\n<td class="text-center">\n    <div class="btn-group text-left navbar-btn dropdown">\n\t\t<a title="' +
__e( i18next.t('Boards') ) +
'" class="btn btn-default btn-xs ';
 if(user.attributes.owner_board_count != 0){ ;
__p += 'dropdown-toggle';
}else{;
__p += 'js-no-action';
};
__p += '"\n\t\t';
 if(user.attributes.owner_board_count != 0){ ;
__p += 'href="#"';
}else{;
__p += 'href="#/users"';
};
__p += '\n\t\t';
 if(user.attributes.owner_board_count != 0){ ;
__p += 'data-toggle="dropdown"';
};
__p += '>' +
__e( user.attributes.owner_board_count) +
'</a>\n\t\t\t';
 if(user.attributes.owner_board_count != 0){ ;
__p += '\n\t\t\t\t<ul class="dropdown-menu arrow arrow-left  text-left" role="boards" id="js-user-activity-menu-response-' +
__e( user.attributes.id) +
'">\n\t\t\t\t</ul>\n\t\t   ';
};
__p += '\n\t</div>\n</td>\n<td class="text-center">\n    <div class="btn-group text-left navbar-btn dropdown">\n\t\t<a title="' +
__e( i18next.t('Boards') ) +
'" class="btn btn-default btn-xs ';
 if(user.attributes.member_board_count != 0){ ;
__p += 'dropdown-toggle';
}else{;
__p += 'js-no-action';
};
__p += '"\n\t\t';
 if(user.attributes.member_board_count != 0){ ;
__p += 'href="#"';
}else{;
__p += 'href="#/users"';
};
__p += '\n\t\t';
 if(user.attributes.member_board_count != 0){ ;
__p += 'data-toggle="dropdown"';
};
__p += '>' +
__e( user.attributes.member_board_count) +
'</a>\n\t\t\t';
 if(user.attributes.member_board_count != 0){ ;
__p += '\n\t\t\t\t<ul class="dropdown-menu arrow arrow-left  text-left" role="boards" id="js-user-activity-menu-response-' +
__e( user.attributes.id) +
'">\n\t\t\t\t</ul>\n\t\t   ';
};
__p += '\n\t</div>\n</td>\n<td class="text-center">\n    <a href="#" class="js-no-action" title="' +
__e( user.attributes.user_login_count) +
'"><span class="navbar-btn">' +
__e( user.attributes.user_login_count) +
'</span></a>\n</td>\n<td class="text-center">\n    <a href="#" class="js-no-action">\n\t    ';
 if(user.get('last_login_date') !== null){ ;
__p += '<abbr class="timeago" title="' +
__e( user.get('last_login_date') ) +
'">' +
__e( user.get("last_login_date") ) +
'</abbr>';
}else{;
__p += '-';
};
__p += '\n\t</a>\n</td>\n<td class="text-center">\n    <a href="#" class="js-no-action" title=' +
__e( user.attributes.last_login_ip) +
' ' +
__e( user.attributes.login_country_name ) +
' ' +
__e( user.attributes.login_city_name ) +
'">\n\t\t<span class="show">' +
__e( user.attributes.last_login_ip) +
'</span> \n\t\t\t\t';
 if(!_.isEmpty(user.attributes.login_country_iso2)){ ;
__p += '\n\t\t\t\t    <span class="flags flag-' +
__e( user.attributes.login_country_iso2) +
' top-smspace" title="' +
__e( user.attributes.login_country_name ) +
'">' +
__e( user.attributes.login_country_name ) +
'</span>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t';
 if(!_.isEmpty(user.attributes.login_city_name)){ ;
__p += ' ' +
__e( user.attributes.login_city_name );
 } ;
__p += '\n\t</a>\n</td>\n<td class="text-center">\n    <a href="#" class="js-no-action"><abbr class="timeago" title="' +
__e( user.get('created') ) +
'">' +
__e( user.get("created") ) +
'</abbr></a>\n</td> \n<td class="text-center">\n    <a href="#" class="js-no-action" title=' +
__e( user.attributes.registered_ip) +
' ' +
__e( user.attributes.register_country_name ) +
' ' +
__e( user.attributes.register_city_name ) +
'">\n\t    <span class="show">' +
__e( user.attributes.registered_ip) +
'</span> \n\t\t\t';
 if(!_.isEmpty(user.attributes.register_country_iso2)){ ;
__p += '\n\t\t\t\t<span class="flags flag-' +
__e( user.attributes.register_country_iso2) +
' top-smspace" title="' +
__e( user.attributes.register_country_name ) +
'">' +
__e( user.attributes.register_country_name ) +
'</span>\n\t\t\t';
 } ;
__p += '\n\t\t';
 if(!_.isEmpty(user.attributes.register_city_name)){ ;
__p += ' <span>' +
__e( user.attributes.register_city_name ) +
'</span>';
 } ;
__p += '\n\t</a>\n</td>\n<td class="text-center">\n\t<div class="dropdown btn-group">  \n\t<button class="btn btn-default" type="button">';
if(user.attributes.role_id == 1){;
__p += ' Admin ';
}else if(user.attributes.role_id == 2){;
__p += ' ' +
__e( i18next.t("User") ) +
' ';
}else{;
__p += ' ' +
__e( i18next.t("Guest") );
};
__p += '</button>\n\t\t<button aria-expanded="false" data-toggle="dropdown" class="btn btn-default dropdown-toggle" type="button">\n\t\t    <span class="caret"></span><span class="sr-only">' +
__e( i18next.t("Toggle Dropdown") ) +
'</span>\n        </button>\n\t\t\t    <ul class="dropdown-menu arrow arrow-right" role="menu">\n\t\t\t\t\t<li><a href="#" class="';
 if(user.attributes.role_id == 1){;
__p += 'js-no-action';
}else{;
__p += 'js-change-user-role';
};
__p += '" data-role-id="1">' +
__e( i18next.t("Admin") ) +
' ';
 if(user.attributes.role_id == 1){;
__p += '<i class="icon-ok"></i>';
};
__p += '</a></li>\n\t\t\t\t\t<li><a href="#" class="';
 if(user.attributes.role_id == 2){;
__p += 'js-no-action';
}else{;
__p += 'js-change-user-role';
};
__p += '" data-role-id="2">' +
__e( i18next.t("User") ) +
' ';
 if(user.attributes.role_id == 2){;
__p += '<i class="icon-ok"></i>';
};
__p += '</a></li>\n\t\t\t\t</ul>\n\t</div>\n</td>\n\n\n<td>\n   <ul class="list-inline list-group-item-text">\n\t   <li class="navbar-btn"><a href="#" title="' +
__e( i18next.t('Activities') ) +
'" class="btn btn-default btn-xs js-all-user-activities">' +
__e( i18next.t("Activities") ) +
'</a></li>\n\t   <li>\n\t\t<ul class="list-inline">\n\t\t\t<li class="navbar-btn">\n\t\t\t\t<a href="#" class="btn btn-default btn-xs ';
if(parseInt(user.attributes.is_active) === 1){;
__p += 'js-block-user';
}else{;
__p += 'js-unblock-user';
};
__p += '"  title="' +
__e( i18next.t('Block') ) +
'" ';
 if(user.attributes.role_id == 1){;
__p += ' disabled="disabled" ';
 } ;
__p += '>\n\t            <i class="icon-exclamation"></i>\n\t\t\t    <span>';
if(parseInt(user.attributes.is_active) === 1){;
__p +=
__e( i18next.t("Block") );
}else{;
__p +=
__e( i18next.t("Unblock") );
};
__p += '</span></a>\n\t\t    </li>  \n\t\t\t<li class="navbar-btn">\n\t\t\t    <span class="dropdown navbar-btn">\n\t\t\t\t<a aria-expanded="false" data-toggle="dropdown" class="btn btn-primary btn-xs" href="#" ';
 if(user.attributes.role_id == 1){;
__p += ' disabled="disabled" ';
 } ;
__p += ' >\n\t\t\t\t\t<i class="icon-remove"></i> ' +
__e( i18next.t("Delete") ) +
'\n\t\t\t    </a>\n\t\t\t\t\n\t\t\t\t<ul class="dropdown-menu dropdown-menu-right arrow arrow-right col-xs-12">\n\t\t\t\t\t\t<li class="col-lg-12 clearfix text-center"> <div><span class="col-xs-10"><strong>' +
__e( i18next.t("Delete User") + '?' ) +
'</strong></span><a class="js-close-popover pull-right" href="#/users"><i class="icon-remove "></i></a></div> </li>\n\t\t\t\t\t\t<li class="col-lg-12 divider"></li>\n\t\t\t\t\t\t<li class="col-lg-12 text-left">\n\t\t\t\t\t\t   <span class="show">' +
__e( i18next.t("Deleting an user is permanent. There is no undo.") ) +
'</span>\n\t\t\t\t\t\t\t  <div class="col-xs-12 btn-block navbar-btn"><a title="' +
__e( i18next.t('Delete User') ) +
'" class="js-remove-user"><span class="btn btn-primary">' +
__e( i18next.t("Delete") ) +
'</span></a></div>\n\t\t\t\t\t   </li>\n\t             </ul>\n\t\t\t</li>\n\t\t</ul>\n\t   </li>\n    </ul>\n</td>\n';

}
return __p
};

this["JST"]["templates/user_activity"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(!_.isEmpty(activity) && activity != null){  ;
__p += ' \n\t';
 
				var cardLink = '<a href="#/board/' + activity.attributes.board_id + '/card/' + activity.attributes.card_id + '">' + _.escape(activity.attributes.card_name) + '</a>';
				var organizationLink = '<a href="#/organization/' + activity.attributes.organization_id + '">' + _.escape(activity.attributes.organization_name) + '</a>';
			if(activity.attributes.type != 'add_comment' && activity.attributes.type != 'edit_comment') {
				activity.attributes.comment = activity.attributes.comment.replace('##ORGANIZATION_LINK##', organizationLink);
				activity.attributes.comment = activity.attributes.comment.replace('##CARD_LINK##', cardLink);
				activity.attributes.comment = activity.attributes.comment.replace('##LABEL_NAME##', _.escape(activity.attributes.label_name));
				activity.attributes.comment = activity.attributes.comment.replace('##CARD_NAME##', _.escape(activity.attributes.card_name));
				activity.attributes.comment = activity.attributes.comment.replace('##DESCRIPTION##', _.escape(activity.attributes.card_description));
				activity.attributes.comment = activity.attributes.comment.replace('##LIST_NAME##', _.escape(activity.attributes.list_name));
				activity.attributes.comment = activity.attributes.comment.replace('##BOARD_NAME##', _.escape(activity.attributes.board_name));
				activity.attributes.comment = activity.attributes.comment.replace('##USER_NAME##', '<span class="h5">'+_.escape(activity.attributes.full_name)+'</span>');
				activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_ITEM_NAME##', _.escape(activity.attributes.checklist_item_name));
				activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_ITEM_PARENT_NAME##', _.escape(activity.attributes.checklist_item_parent_name));
				activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_NAME##', _.escape(activity.attributes.checklist_name));
			} else {
					var comment = activity.attributes.full_name + ' commented in card ' + cardLink;
			}
		;
__p += '   \n\t\t<ul class="media-list">\n\t\t\t<li class="media">\n\t\t\t\t<a data-placement="bottom" title="' +
__e( activity.attributes.full_name) +
' (' +
__e( activity.attributes.username) +
')" data-toggle="tooltip" href="#/user/' +
__e( activity.attributes.user_id ) +
'" class="pull-left">\t\t\t\t\t\t\t\t\n\t\t\t\t\t';
 if(!_.isEmpty(activity.attributes.profile_picture_path)) { 
						var profile_picture_path = activity.showImage('User', activity.attributes.user_id, 'normal_thumb' );
					;
__p += '\n\t\t\t\t\t\t<img src="' +
__e(profile_picture_path ) +
'" alt="[Image: ' +
__e(activity.attributes.full_name ) +
']" title="' +
__e(activity.attributes.full_name ) +
' (' +
__e(activity.attributes.username ) +
')" class="img-rounded img-responsive">\n\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t<i class="avatar avatar-color-194 avatar-md img-rounded">' +
__e( activity.attributes.initials ) +
'</i>\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t</a>\n\t\t\t\t<div class="media-body">\n\t\t\t\t\t<div class="media-heading">\n\t\t\t\t\t\t';
 if(activity.attributes.type == 'add_comment' || activity.attributes.type == 'edit_comment') { ;
__p += '\t\n\t\t\t\t\t\t\t<span>' +
((__t = ( comment )) == null ? '' : __t) +
'</span>\n\t\t\t\t\t\t\t' +
((__t = ( converter.makeHtml(makeLink(_.escape(activity.attributes.comment), activity.attributes.board_id)) )) == null ? '' : __t) +
'\n\t\t\t\t\t\t';
 } else{;
__p += '\n\t\t\t\t\t\t\t' +
((__t = ( converter.makeHtml(makeLink(activity.attributes.comment, activity.attributes.board_id)) )) == null ? '' : __t) +
' \n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t';
 if(activity.attributes.difference != null && _.contains(['update_card_comment', 'edit_list', 'edit_organization', 'edit_board', 'update_card_checklist', 'update_profile', 'edit_card'], activity.attributes.type)) { ;
__p += '\n\t\t\t\t\t\t\t<div class="thumbnail media-body no-mar">\n\t\t\t\t\t\t\t\t';
 _.each(activity.attributes.difference, function(difference) { ;
__p += '\n\t\t\t\t\t\t\t\t\t' +
((__t = ( converter.makeHtml(difference) )) == null ? '' : __t) +
'\n\t\t\t\t\t\t\t\t';
 }); ;
__p += '\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t<small class="pull-left"><abbr class="timeago pull-left text-muted" title="' +
__e( activity.attributes.created ) +
'">' +
__e( activity.attributes.created ) +
'</abbr>';
 if(!_.isEmpty(activity.attributes.board_name)){ ;
__p += '<a class="pull-left" href="#/board/' +
((__t = ( activity.attributes.board_id )) == null ? '' : __t) +
'">&nbsp;on&nbsp;' +
__e( activity.attributes.board_name ) +
'</a>';
 } ;
__p += '</small>\n\t\t\t\t\t\t<div class="clearfix">\n\t\t\t\t\t\t\t\t<small class="pull-left">\n\t\t\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && activity.attributes.type == "add_comment" && type != "all") { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<div class="js-acticity-action-' +
__e( activity.attributes.id ) +
' pull-left">  \n\t\t\t\t\t\t\t\t\t\t\t<ul class="list-inline col-xs-offset-0">\n\t\t\t\t\t\t\t\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "edit_comment"}))){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t<li><a title="' +
__e( i18next.t('Edit') ) +
'" class="js-show-edit-activity js-edit-activity-link-' +
__e( activity.attributes.id ) +
'" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-edit"></i>' +
__e( i18next.t("Edit") ) +
'</a></li>\n\t\t\t\t\t\t\t\t\t\t\t';
 } ;
__p += '         \n\t\t\t\t\t\t\t\t\t\t\t\t<li><a title="' +
__e( i18next.t('Reply') ) +
'" class="js-show-reply-activity-form js-reply-activity-link-' +
__e( activity.attributes.id ) +
'" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-repeat"></i>' +
__e( i18next.t("Reply") ) +
'</a></li>\n\t\t\t\t\t\t\t\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "delete_comment"}))){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t<li class="dropdown">\n\t\t\t\t\t\t\t\t\t\t\t\t\t<a title="' +
__e( i18next.t('Delete') ) +
'" class="dropdown-toggle js-show-confirm-comment-delete" data-toggle="dropdown" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-remove"></i>' +
__e( i18next.t("Delete") ) +
'</a>\n\t\t\t\t\t\t\t\t\t\t\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<li id="js-acticity-actions-response-' +
__e( activity.attributes.id ) +
'" class="js-dropdown-popup dropdown-popup"></li>\n\t\t\t\t\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t\t';
 } else if(activity.attributes.revisions != null && activity.attributes.revisions != "" && (parseInt(authuser.user.id) == 1 || current_user_can_undo_it == true )){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "undo_activity"}))){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t';
 if(_.isUndefined(activity.from_footer)) { ;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t<div class="js-acticity-action-' +
__e( activity.attributes.id ) +
'"><ul class="list-inline col-xs-offset-0"><li><a title="' +
__e( i18next.t('Undo') ) +
'" class="js-undo2 pull-left" href="#" data-activity-id="' +
__e( activity.attributes.id ) +
'"><i class="icon-undo"></i>' +
__e( i18next.t("Undo") ) +
'</a></li></ul></div>\n\t\t\t\t\t\t\t\t\t\t\t';
 };
__p += '\t\n\t\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t<span class="pull-left col-xs-12 js-activity-reply-form-response-' +
__e( activity.attributes.id ) +
'"></span>\n\t\t\t\t\t\t\t\t</small>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</li>\n\t\t\t<li><hr></li>\n\t\t</ul>\n';
 }else{ ;
__p += '\n\t<span id="js-no-activities" class="alert alert-info col-xs-12">' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('activities')] }) ) +
'</span>\n';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/user_activity_menu"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<li class="js-dropdown-popup dropdown-popup">\n\t<a href="#" class="';
 if (user.attributes.joined_board_count !== 0) {;
__p += 'js-user-board-list';
};
__p += '">\n\t<p>On ' +
__e( user.attributes.joined_board_count) +
' ' +
__e( i18next.t("Boards") ) +
'</p></a></li>';

}
return __p
};

this["JST"]["templates/user_board_list"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 	
	var style = '';		
	if (user_board.attributes.background_picture_url) {
		var background_picture_url = user_board.attributes.background_picture_url.replace("_XXXX.jpg", "_s.jpg");
		style = 'background-image:url(' + background_picture_url + ');background-size:cover;';
	} else if (user_board.attributes.background_pattern_url) {
		background_pattern_url = user_board.attributes.background_pattern_url.replace("_XXXX.jpg", "_s.jpg");
		style = 'background-image:url(' + background_pattern_url + ');background-size:cover;';
	} else if (user_board.attributes.background_color){
		style = 'background-color:' + user_board.attributes.background_color + ';color:#ffffff;';
	} else {
		style = '';
	}
;
__p += '\n<a href="#/board/' +
__e( user_board.attributes.board_id) +
'">\n\t<span style="' +
((__t = ( style )) == null ? '' : __t) +
'" class="preview-thumbnail"></span>\n\t<span class="details navbar-btn">\n\t\t<span title="' +
__e( user_board.attributes.name ) +
'" class="board-list-item-name navbar-btn">' +
__e( user_board.attributes.name ) +
'</span>\n\t</span> \n</a> ';

}
return __p
};

this["JST"]["templates/user_boards_listing_menu"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div>\n    <div class="col-xs-12 text-center clearfix">\n            <span class="col-xs-10"><strong>' +
__e( i18next.t("Boards for") ) +
'</span><span title="' +
__e( boards.username) +
'"> ' +
__e( boards.username) +
'</span></strong></span><a href="#" class="js-close-popover pull-right"><i class="icon-remove"></i></a>\n    </div>\n    <div class="col-xs-12 divider"></div>\n    <div class="col-xs-12">\n        ';

			boards.each(function(board) {
		;
__p += '\n\t\t\t<li><a href="#/board/' +
__e( board.attributes.board_id) +
'">' +
__e( board.attributes.board_name) +
'</a></li>\n\t\t';
					
		   });
		;
__p += '\t\n    </div>\n</div>';

}
return __p
};

this["JST"]["templates/user_cards"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<h3><a href="#/board/' +
__e( card_user[0].attributes.board_id) +
'">' +
__e( key ) +
'</a></h3>\n<div class="board-viewlist col-xs-12 table-responsive">\n\t<table class="table">\n\t\t<thead>\n\t\t\t<tr>\n\t\t\t\t<th>\n\t\t\t\t\t<ul class="list-inline navbar-btn clearfix">\t\n\t\t\t\t\t\t<li class="col-md-1 col-xs-2">' +
__e( i18next.t("ID") ) +
'</li>\n\t\t\t\t\t\t<li class="col-md-4 col-xs-3">' +
__e( i18next.t("Card Name") ) +
'</li>\n\t\t\t\t\t\t<li class="col-md-4 col-xs-3">' +
__e( i18next.t("List Name") ) +
'</li>\n\t\t\t\t\t\t<li class="col-md-3 col-xs-4"></li>                            \n\t\t\t\t\t</ul>\n\t\t\t\t</th>\n\t\t\t</tr>\n\t\t</thead>\n\t\t<tbody class="js-card-list-view-11">\n\t';
 _.each(card_user, function(user_card) { ;
__p += '\n\t\t\t<tr>\n\t\t\t<td>\n\t\t\t\t<div class="panel cur" id="js-card-1449">\n\t\t\t\t\t<div class="panel-body"> \n\t\t\t\t\t\t<ul class="list-inline navbar-btn clearfix">\n\t\t\t\t\t\t\t<li class="col-md-1 col-xs-2"><span class="card-id">#' +
__e( user_card.id) +
'</span></li>\n\t\t\t\t\t\t\t<li class="col-md-4 col-xs-3 js-open-model-car-view" data-id="' +
__e( user_card.id) +
'">' +
__e( user_card.attributes.name ) +
'</li> \n\t\t\t\t\t\t\t<li class="col-md-4 col-xs-3">' +
__e( user_card.attributes.list_name ) +
'</li>\n\t\t\t\t\t\t\t<li class="col-md-3 col-xs-4">\n\t\t\t\t\t\t\t\t<ul class="list-inline text-muted clearfix">\n\t\t\t\t\t\t\t\t\t';
 if(user_card.attributes.cards_subscriber_count > 0){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<li><small><span class="icon-eye-open"></span></small></li>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += ' \n\t\t\t\t\t\t\t\t\t';
 if(user_card.attributes.card_voter_count > 0){ ;
__p += '\n\t\t\t\t\t\t\t\t\t<li><small><span class="icon-thumbs-up"></span><span>' +
__e( user_card.attributes.card_voter_count ) +
'</span></small></li>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t';
 if(user_card.attributes.comment_count > 0){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<li><small><span class="icon-comment"></span><span>' +
__e( user_card.attributes.comment_count ) +
'</span></small></li>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t';
 if(!_.isEmpty(user_card.attributes.description)){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<li><small><span class="icon-align-left"></span><span></span></small></li>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t';
 if(user_card.attributes.checklist_item_count > 0){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<li><small>';
 if(user_card.attributes.checklist_item_completed_count == user_card.attributes.checklist_item_count) { ;
__p += '<div class="label label-success"> ';
 } ;
__p += '<span class="icon-list-ul"></span><span>' +
__e( user_card.attributes.checklist_item_completed_count ) +
'/' +
__e( user_card.attributes.checklist_item_count ) +
'</span>';
 if(user_card.attributes.checklist_item_completed_count == user_card.attributes.checklist_item_count) { ;
__p += '</div>';
 } ;
__p += '</small></li>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += ' \n\t\t\t\t\t\t\t\t\t';
 if(user_card.attributes.due_date > 0){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<li><small><span class="icon-time"></span><span>' +
__e( user_card.attributes.due_date ) +
'</span></small></li>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += ' \n\t\t\t\t\t\t\t\t\t';
 if(user_card.attributes.attachment_count > 0){ ;
__p += '\n\t\t\t\t\t\t\t\t\t\t<li>\n\t\t\t\t\t\t\t\t\t\t\t<small>\n\t\t\t\t\t\t\t\t\t\t\t\t<span class="icon-paper-clip"></span>\n\t\t\t\t\t\t\t\t\t\t\t\t<span>\n\t\t\t\t\t\t\t\t\t\t\t\t' +
__e( user_card.attributes.attachment_count ) +
'\n\t\t\t\t\t\t\t\t\t\t\t\t</span>\n\t\t\t\t\t\t\t\t\t\t\t</small>\n\t\t\t\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t\t\t\t';
 } ;
__p += ' \n\t\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t\t</li>\n\t\t\t\t\t\t</ul>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</td>\n\t\t</tr>\n\t';
 }); ;
__p += '\n\t </tbody>\n\t</table>\n</div>';

}
return __p
};

this["JST"]["templates/user_dashboard"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 
	var d = new Date();
	var weekday = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
	var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
	var today = weekday[d.getDay()]; 
	var current_month = months[d.getMonth()]; 
	var today_count = 0;
	
	var doing_count = 0;
	var todo_count = 0;
	var done_count = 0;
	
	var current_week_doing_count = 0;
	var current_week_todo_count = 0;
	var current_week_done_count = 0;
	
	var overall_doing_count = 0;
	var overall_todo_count = 0;
	var overall_done_count = 0;
	
	var current_weekwise_doing_count = [0,0,0,0,0,0,0];
	var current_weekwise_todo_count = [0,0,0,0,0,0,0];
	var current_weekwise_done_count = [0,0,0,0,0,0,0];
	
	var last_weekwise_doing_count = [0,0,0,0,0,0,0];
	var last_weekwise_todo_count = [0,0,0,0,0,0,0];
	var last_weekwise_done_count = [0,0,0,0,0,0,0];
	
	if(data.dashboard.today) {
		doing_count = (data.dashboard.today.DOING) ? (data.dashboard.today.DOING) : 0;
		todo_count = (data.dashboard.today.TODO) ? (data.dashboard.today.TODO) : 0;
		done_count = (data.dashboard.today.DONE) ? (data.dashboard.today.DONE) : 0;
		today_count = parseInt(doing_count) + parseInt(today_count) + parseInt(done_count);
	} 
	
	if(data.dashboard.current_week) {
		current_week_doing_count = (data.dashboard.current_week.DOING) ? (data.dashboard.current_week.DOING) : 0;
		current_week_todo_count = (data.dashboard.current_week.TODO) ? (data.dashboard.current_week.TODO) : 0;
		current_week_done_count = (data.dashboard.current_week.DONE) ? (data.dashboard.current_week.DONE) : 0;
	}
	if(data.dashboard.overall) {
		overall_doing_count = (data.dashboard.overall.DOING) ? (data.dashboard.overall.DOING) : 0;
		overall_todo_count = (data.dashboard.overall.TODO) ? (data.dashboard.overall.TODO) : 0;
		overall_done_count = (data.dashboard.overall.DONE) ? (data.dashboard.overall.DONE) : 0;
	}
	
	if(data.dashboard.current_weekwise) {
		current_weekwise_doing_count = (data.dashboard.current_weekwise.DOING) ? (data.dashboard.current_weekwise.DOING) : current_weekwise_doing_count;
		current_weekwise_todo_count = (data.dashboard.current_weekwise.TODO) ? (data.dashboard.current_weekwise.TODO) : current_weekwise_todo_count;
		current_weekwise_done_count = (data.dashboard.current_weekwise.DONE) ? (data.dashboard.current_weekwise.DONE) : current_weekwise_done_count;
	}
	
	if(data.dashboard.last_weekwise) {
		last_weekwise_doing_count = (data.dashboard.last_weekwise.DOING) ? (data.dashboard.last_weekwise.DOING) : last_weekwise_doing_count;
		last_weekwise_todo_count = (data.dashboard.last_weekwise.TODO) ? (data.dashboard.last_weekwise.TODO) : last_weekwise_todo_count;;
		last_weekwise_done_count = (data.dashboard.last_weekwise.DONE) ? (data.dashboard.last_weekwise.DONE) : last_weekwise_done_count;
	}
	
;
__p += '\n<div class="clearfix">\n\t<div class="row">\n\t <div class="col-md-2 col-sm-12 text-center dashboard-organization">\n\t\t<div class="navbar-btn">\n\t\t\t<label class="clearfix"><a title="' +
__e( data.user.full_name ) +
' (' +
__e( data.user.username ) +
')" href="#/user/' +
__e( data.user.id ) +
'">' +
__e( data.user.full_name ) +
' (' +
__e( data.user.username ) +
')</a></label>\n\t\t</div>\n\t\t<div class="navbar-btn">\n\t\t\t';
 if(!_.isEmpty(data.user_profile_picture)) { ;
__p += '\n\t\t\t\t<img title="' +
__e( data.user.full_name ) +
' (' +
__e( data.user.username ) +
')" alt="' +
__e( data.user.username ) +
'" src="' +
__e( data.user_profile_picture ) +
'" width="147" height="145" class="thumbnail center-block">\n\t\t\t';
 } else { ;
__p += '\n\t\t\t\t<i class="avatar avatar-color-194 avatar-lg img-rounded">' +
((__t = ( (data.user.initials) )) == null ? '' : __t) +
'</i>\n\t\t\t';
 } ;
__p += '\n\t\t</div>\n\t\t<div class="clearfix dropdown navbar-btn">\n\t\t\t<a href="#" title="Organizations" class="btn btn-primary navbar-btn" data-toggle="dropdown">' +
__e( data.organizations.length ) +
' ' +
__e( i18next.t('Organizations') ) +
' <i class="caret"></i> </a>\n\t\t\t <ul class="dropdown-menu arrow dropdown-menu-right text-left">\n\t\t\t\t ';
 _.each(data.organizations, function(item, key) { ;
__p += ' \n\t\t\t\t\t<li><a href="#/organization/' +
__e( item.attributes.id ) +
'" title="' +
__e( item.attributes.name ) +
'"> ' +
__e( item.attributes.name ) +
' </a></li>\n\t\t\t\t';
 }); ;
__p += ' \n\t\t\t </ul>\n\t\t</div>\n\t </div>\n\t<div class="col-md-10 col-sm-12 clearfix">\n\t  <div class="col-sm-3 col-xs-12">\n\t\t  <div class="row thumbnail">\n\t\t   <div class="pull-left col-md-4 col-xs-6">\n\t\t\t <h4>' +
__e( i18next.t('Today') ) +
'</h4> \n\t\t\t <div class="thumbnail text-center navbar-btn">\n\t\t\t\t  <div class="sep-bot"> \n\t\t\t\t\t<div class="bg-default h6 text-muted list-group-item-heading">' +
__e( current_month ) +
'</div>\n\t\t\t\t\t<div class="h3 list-group-item-heading">' +
__e( d.getDate() ) +
'</div>\n\t\t\t\t  </div>\n\t\t\t\t  <div>' +
__e( today ) +
'</div>\n\t\t\t </div>\n\t\t   </div>\n\t\t\t<ul class="list-unstyled chart-block list-group-item-text pull-right">\n\t\t\t\t<li class="list-group-item clearfix no-bor">\n\t\t\t\t\t<a class="show" href="#">\n\t\t\t\t\t\t<div id="doughnutChart" class="chart js-chart" data-todo="' +
__e( todo_count ) +
'" data-doing="' +
__e( doing_count ) +
'" data-done="' +
__e( done_count ) +
'"></div>\n\t\t\t\t\t</a>\n\t\t\t\t</li>\n\t\t\t</ul>\n\t\t\t<div class="col-xs-12 pull-right navbar-btn">\n\t\t\t\t<a href="#" class="btn btn-xs btn-primary pull-right row" data-toggle="dropdown"><i class="caret"></i></a>\n\t\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t<li class="dashboard-search" data-search="today_todo"><a href="#" title="Today Todo">Today Todo</a></li>\n\t\t\t\t\t<li class="dashboard-search" data-search="today_doing"><a href="#" title="Today Doing">Today Doing</a></li>\n\t\t\t\t\t<li class="dashboard-search" data-search="today_done"><a href="#" title="Today Done">Today Done</a></li>\n\t\t\t\t</ul>\n\t\t\t</div>\n\t\t </div>\n\t  </div>\n\t  <div class="col-sm-4 col-xs-12">\n\t\t  <div class="col-xs-12 thumbnail">\n\t\t   <div class="pull-left col-lg-4 col-md-6 col-xs-12">\n\t\t\t   <h4>' +
__e( i18next.t('Week') ) +
'</h4>\n\t\t\t   <ul class="list-inline week-chart-date navbar-btn">\n\t\t\t\t   <li class="thumbnail text-center navbar-btn col-xs-4">\n\t\t\t\t   \t  <div class="sep-bot"> \n\t\t\t\t\t\t<div class="bg-default h6 text-muted list-group-item-heading ">' +
__e( data.dashboard.week_start_month ) +
'</div>\n\t\t\t\t\t\t<div class="h3 list-group-item-heading ">' +
__e( data.dashboard.week_start_day ) +
'</div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t  <div>' +
__e( i18next.t('Mon') ) +
'</div>\n\t\t\t\t\t</li>\n\t\t\t\t\t<li> ' +
__e( i18next.t('to') ) +
' </li>\n\t\t\t\t\t<li class="thumbnail text-center navbar-btn col-xs-4">\n\t\t\t\t\t  <div class="sep-bot"> \n\t\t\t\t\t\t<div class="bg-default h6 text-muted list-group-item-heading ">' +
__e( data.dashboard.week_end_month ) +
'</div>\n\t\t\t\t\t\t<div class="h3 list-group-item-heading ">' +
__e( data.dashboard.week_end_day ) +
'</div>\n\t\t\t\t\t  </div>\n\t\t\t\t\t  <div>' +
__e( i18next.t('Sun') ) +
'</div>\n\t\t\t\t\t</li>\n\t\t\t\t</ul>\n\t\t\t</div>\n\t\t\t<ul class="list-unstyled chart-block list-group-item-text pull-right">\n\t\t\t\t<li class="list-group-item clearfix no-bor">\n\t\t\t\t\t<a class="show" href="#">\n\t\t\t\t\t\t<div id="doughnutChart" class="chart js-chart" data-todo="' +
__e( current_week_todo_count ) +
'" data-doing="' +
__e( current_week_doing_count ) +
'" data-done="' +
__e( current_week_done_count ) +
'"></div>\n\t\t\t\t\t</a>\n\t\t\t\t</li>\n\t\t\t</ul>\n\t\t\t<div class="col-xs-12 pull-right navbar-btn">\n\t\t\t\t<a href="#" class="btn btn-xs btn-primary pull-right row" data-toggle="dropdown"><i class="caret"></i></a>\n\t\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t<li class="dashboard-search" data-search="week_todo"><a href="#" title="Week Todo">Week Todo</a></li>\n\t\t\t\t\t<li class="dashboard-search" data-search="week_doing"><a href="#" title="Week Doing">Week Doing</a></li>\n\t\t\t\t\t<li class="dashboard-search" data-search="week_done"><a href="#" title="Week Done">Week Done</a></li>\n\t\t\t\t</ul>\n\t\t\t</div>\n\t\t </div>\n\t  </div>\n\t  <div class="col-sm-3 col-xs-12">\n\t\t  <div class="row thumbnail">\n\t\t\t   <div class="pull-left col-xs-5">\n\t\t\t\t\t<h4>' +
__e( i18next.t('Overall') ) +
'</h4>\n\t\t\t   </div>\n\t\t\t   <ul class="list-unstyled chart-block list-group-item-text pull-right">\n\t\t\t\t<li class="list-group-item clearfix no-bor">\n\t\t\t\t\t<a class="show" href="#">\n\t\t\t\t\t\t<div id="doughnutChart" class="chart js-chart" data-todo="' +
__e( overall_todo_count ) +
'" data-doing="' +
__e( overall_doing_count ) +
'" data-done="' +
__e( overall_done_count ) +
'"></div>\n\t\t\t\t\t</a>\n\t\t\t\t</li>\n\t\t\t</ul>\n\t\t\t<div class="col-xs-12 pull-right navbar-btn">\n\t\t\t\t<a href="#" class="btn btn-xs btn-primary pull-right row" data-toggle="dropdown"><i class="caret"></i></a>\n\t\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t<li class="dashboard-search" data-search="overall_todo"><a href="#" title="Overall Todo">Overall Todo</a></li>\n\t\t\t\t\t<li class="dashboard-search" data-search="overall_doing"><a href="#" title="Overall Doing">Overall Doing</a></li>\n\t\t\t\t\t<li class="dashboard-search" data-search="overall_done"><a href="#" title="Overall Done">Overall Done</a></li>\n\t\t\t\t</ul>\n\t\t\t</div>\n\t\t </div>\n\t   </div>\n\t\t<div class="clearfix col-sm-2 col-xs-12 pull-right text-center">\n\t\t\t<div class="clearfix col-xs-12 thumbnail">\n\t\t\t\t<h4>' +
__e( i18next.t('Unassigned') ) +
'</h4>\n\t\t\t\t<div class="clearfix h1">\n\t\t\t\t\t<div class="dashboard-search" data-search="unassigned">' +
__e( !_.isUndefined(data.dashboard.unassigned) ? data.dashboard.unassigned : 0 ) +
'</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="well-sm navbar-btn"></div>\n\t\t\t\t<div class="well-sm"></div>\n\t\t\t\t<div class="col-xs-12 pull-right navbar-btn">\n\t\t\t\t<a href="#" class="btn btn-xs btn-primary pull-right row" data-toggle="dropdown"><i class="caret"></i></a>\n\t\t\t\t<ul class="dropdown-menu arrow arrow-right">\n\t\t\t\t\t<li class="dashboard-search" data-search="unassigned"><a href="#" title="Unassigned">Unassigned</a></li>\n\t\t\t\t</ul>\n\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t   <div class="col-xs-12 clearfix navbar-btn">\n\t\t\t<div class="col-sm-6 col-xs-12 clearfix navbar-btn">\n\t\t\t\t<div class="col-sm-4 h4"> ' +
__e( i18next.t('This week') ) +
'</div> \n\t\t\t\t<div class="col-md-8 col-xs-12">\n\t\t\t\t\t<span class="sparklines" data-todo="' +
__e( (current_weekwise_todo_count).join() ) +
'" data-doing="' +
__e( (current_weekwise_doing_count).join() ) +
'" data-done="' +
__e( (current_weekwise_done_count).join() ) +
'" ></span>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="col-sm-6 col-xs-12 clearfix navbar-btn"> \n\t\t\t\t<div class="col-sm-4 h4"> ' +
__e( i18next.t('Last week') ) +
'</div> \n\t\t\t\t<div class="col-md-8 col-xs-12">\n\t\t\t\t\t<span class="sparklines test" data-todo="' +
__e( (last_weekwise_todo_count).join() ) +
'" data-doing="' +
__e( (last_weekwise_doing_count).join() ) +
'" data-done="' +
__e( (last_weekwise_done_count).join() ) +
'" ></span>\n\t\t\t\t</div>\n\t\t\t</div>\n\t   </div>\n\t   <div class="col-xs-12 text-center navbar-btn">\n\t\t\t<ul class="list-inline navbar-btn">\n\t\t\t\t';
 if(!_.isUndefined(data.user.role_id) && data.user.role_id === "1") { ;
__p += '\n\t\t\t\t<li class="navbar-right"><i class="icon-warning-sign text-warning"></i><small class="text-muted">' +
__e( i18next.t('Todo, Doing, Done are as configured in ') ) +
'<a href="#/settings/12" title="settings" class="text-primary"> ' +
__e( i18next.t('card workflow settings') ) +
' </a><small></li>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t</ul>\n\t   </div>\n\t</div>\n  </div>\n</div>\n<div class="clearfix dashboard-header">\n\t<div class="col-xs-12">\n\t\t<hr>\n\t\t<span class="pull-left h4">' +
((__t = (data.dashboard.page_title)) == null ? '' : __t) +
'</span>\n\t\t<ul class="nav nav-pills navbar-right">\n\t\t\t<li class="';
  var fragment = Backbone.history.fragment; var fragments = fragment.split('/'); if(fragment.indexOf('boards')  != -1 && fragments.length == 1){;
__p += 'active';
};
__p += '"><a href="#/boards" title="' +
__e( i18next.t('My Boards') ) +
'" class="text-muted list-group-item-text navbar-btn h4"><i class="icon-user"></i></a></li>\n\t\t\t<li class="';
 if(Backbone.history.fragment.indexOf('boards/starred') != -1){;
__p += 'active';
};
__p += '"><a href="#/boards/starred" title="' +
__e( i18next.t('Starred Boards') ) +
'" class="text-muted list-group-item-text navbar-btn h4"><i class="icon-star"></i></a></li>\n\t\t\t<li class="';
 if(Backbone.history.fragment.indexOf('boards/closed') != -1){;
__p += 'active';
};
__p += '"><a href="#/boards/closed" title="' +
__e( i18next.t('Closed Boards') ) +
'" class="text-muted list-group-item-text navbar-btn h4"><i class="icon-th-large"></i></a></li>\n\t\t</ul>\n\t</div>\n</div>\n';

}
return __p
};

this["JST"]["templates/user_index_container"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="well-sm"></div>\n<section class="clearfix">\n <div class="col-xs-12">\n\t<ul class="nav nav-pills text-center thumbnail js-filter-list">\n\t\t<li><a class="js-filter cur" data-filter="active" title="' +
__e( i18next.t('Active') ) +
'"><span class="show"><strong>' +
__e( filter_count.active ) +
'</strong></span>' +
__e( i18next.t('Active') ) +
'</a></li>\n\t\t<li><a class="js-filter cur" data-filter="inactive" title="' +
__e( i18next.t('Inactive') ) +
'"><span class="show"><strong>' +
__e( filter_count.inactive ) +
'</strong></span>' +
__e( i18next.t('Inactive') ) +
'</a></li>\n\t\t';
 if (!_.isEmpty(LDAP_LOGIN_ENABLED) && LDAP_LOGIN_ENABLED == "true") { ;
__p += '\n\t\t\t<li><a class="js-filter cur" data-filter="ldap" title="' +
__e( i18next.t('LDAP') ) +
'"><span class="show"><strong>' +
__e( filter_count.ldap ) +
'</strong></span>' +
__e( i18next.t('LDAP') ) +
'</a></li>\n\t\t';
 } ;
__p += '\n\t\t';
 if(!_.isEmpty(roles)){ 
			_.each(roles, function(role) {
		;
__p += '\n\t\t\t<li><a class="js-filter cur" data-filter="' +
__e( role.id ) +
'" title="' +
__e( role.name ) +
'"><span class="show"><strong>' +
__e( role.count ) +
'</strong></span>' +
__e( i18next.t(role.name) ) +
'</a></li>\n\t\t';
 });
		} ;
__p += '\n\t\t';
 var all = parseInt(filter_count.active) + parseInt(filter_count.inactive); ;
__p += '\n\t\t<li class="active"><a href="#/users" title="' +
__e( i18next.t('All') ) +
'"><span class="show"><strong>' +
__e(  all ) +
'</strong></span>' +
__e( i18next.t('All') ) +
'</a></li>\n\t\t<li class="pull-right h4"><form id="UserSearch" name="UserSearch" class="form-horizontal col-xs-12"><input type="text" placeholder="Search" name="user_search" id="user_search" class="form-control" /></form></li>\n\t</ul>\n </div>\n</section>\n<section>\n<div class="well-sm"></div>\n<form role="form" class="col-xs-12">\n\t<div class="table-responsive">\n\t\t<table class="table table-striped table-bordered table-hover list-group-item-text">\n\t\t<thead>\n                <tr class="active">\n                  <th rowspan="2" class="text-center">' +
__e( i18next.t("Select") ) +
'</th>\n\t\t\t\t  <th rowspan="2" class="col-xs-2"><span class="js-sort cur" data-field="username" data-direction="asc" title="' +
__e( i18next.t('User') ) +
'"><span class="icon-caret-down"></span>' +
__e( i18next.t("User") ) +
'</span></th>\n                  <th colspan="3" class="text-center">' +
__e( i18next.t("Organizations") ) +
'</th>\n                  <th colspan="3" class="text-center">' +
__e( i18next.t("Boards") ) +
'</th>\n                  <th colspan="3" class="text-center">' +
__e( i18next.t("Login") ) +
'</th>\n                  <th colspan="2" class="text-center">' +
__e( i18next.t("Registered") ) +
'</th>\n                  <th rowspan="2" class="text-center col-xs-1"><span class="js-sort cur" data-field="role_id" data-direction="asc" title="' +
__e( i18next.t('Role') ) +
'"><span class="icon-caret-down hide"></span>' +
__e( i18next.t("Role") ) +
'</span></th>\n\t\t\t\t  <th rowspan="2" class="text-center">' +
__e( i18next.t("Actions") ) +
'</th>\n                </tr>\n                <tr class="active">\n\t\t\t\t  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="created_organization_count" data-direction="asc" title="' +
__e( i18next.t('Created') ) +
'">' +
__e( i18next.t("Created") ) +
'</span></th>\n                  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="owner_organization_count" data-direction="asc" title="' +
__e( i18next.t('Owner') ) +
'">' +
__e( i18next.t("Owner") ) +
'</span></th>\n                  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="member_organization_count" data-direction="asc" title="' +
__e( i18next.t('Member') ) +
'">' +
__e( i18next.t("Member") ) +
'</span></th>\n\t\t\t\t  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="created_board_count" data-direction="asc" title="' +
__e( i18next.t('Created') ) +
'">' +
__e( i18next.t("Created") ) +
'</span></th>\n                  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="owner_board_count" data-direction="asc" title="' +
__e( i18next.t('Owner') ) +
'">' +
__e( i18next.t("Owner") ) +
'</span></th>\n                  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="member_board_count" data-direction="asc" title="' +
__e( i18next.t('Member') ) +
'">' +
__e( i18next.t("Member") ) +
'</span></th>\n                  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="user_login_count" data-direction="asc" title="' +
__e( i18next.t('Count') ) +
'">' +
__e( i18next.t("Count") ) +
'</span></th>\n                  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="last_login_date" data-direction="asc" title="' +
__e( i18next.t('Time') ) +
'">' +
__e( i18next.t("Time") ) +
'</span></th>\n                  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="login_country_name" data-direction="asc" title="' +
__e( i18next.t('IP') ) +
'">' +
__e( i18next.t("IP") ) +
'</span></th>\n\t\t\t\t  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="created" data-direction="asc" title="' +
__e( i18next.t('Time') ) +
'">' +
__e( i18next.t("Time") ) +
'</span></th>\n                  <th class="text-center"><span class="icon-caret-down hide"></span><span class="js-sort cur verticalTableHeader show" data-field="register_country_name" data-direction="asc" title="' +
__e( i18next.t('IP') ) +
'">' +
__e( i18next.t("IP") ) +
'</span></th>\n                </tr>\n\t\t\t\n        </thead>\n\t\t\t<tbody class="js-user-list">\n\t\t\t </tbody>\n\t    </thead>\n        </table>\n\t</div>\n</form>\n<div class="clearfix navbar-btn col-xs-12">\n\t\t  <div class="well-sm navbar-btn"></div>\n          <ul class="list-inline pull-left">\n            <li>' +
__e( i18next.t("Select") ) +
':</li>\n            <li><a href="#/users" class="js-select js-no-pjax" data-checked="js-checkbox-list" title="' +
__e( i18next.t('All') ) +
'">' +
__e( i18next.t("All") ) +
'</a></li>\n            <li><a href="#/users" class="js-select js-no-pjax" data-unchecked="js-checkbox-list" title="' +
__e( i18next.t('None') ) +
'">' +
__e( i18next.t("None") ) +
'</a></li>\n            <li><a title="' +
__e( i18next.t('Blocked') ) +
'" href="#/users" class="js-select" data-unchecked="js-checkbox-active" data-checked="js-checkbox-inactive">' +
__e( i18next.t("Blocked") ) +
'</a></li>\n            <li><a title="' +
__e( i18next.t('Unblocked') ) +
'" href="#/users" class="js-select" data-unchecked="js-checkbox-inactive" data-checked="js-checkbox-active">' +
__e( i18next.t("Unblocked") ) +
'</a></li>\n\t\t\t \t\t\t\t  \n          </ul>\n          <div class="pull-left">\n            <form class="form-inline" role="form">\n              <div class="pr clearfix">\n\t                <select class="js-more-action-user" id="js-more-action">\n\t                  <option value="0">' +
__e( i18next.t("More Actions") ) +
'</option>\n\t                  <option value="1">' +
__e( i18next.t("Block") ) +
'</option>\n\t                  <option value="2">' +
__e( i18next.t("Unblock") ) +
'</option>\n\t                  <option value="3">' +
__e( i18next.t("Delete") ) +
'</option>\n\t                </select>\n                </div>\n            </form>\n          </div>\n\t\t  <div class="pull-right pagination pagination-right pagination-boxes list-group-item-heading"></div>\n      </div>\n</section>';

}
return __p
};

this["JST"]["templates/user_search_result"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {

 if(user != null && _.isUndefined(q)){ ;
__p += '\n\t<a title="' +
__e( user.attributes.full_name ) +
' (' +
__e( user.attributes.username ) +
')" href="#" class="js-add-organization-member row" data-user-id="' +
__e( user.id ) +
'"><span>\n';
 if(!_.isEmpty(user.attributes.profile_picture_path)) { 
	var profile_picture_path = user.showImage('User', user.attributes.id, 'micro_thumb' );
;
__p += '\n\t<img src="' +
__e(profile_picture_path ) +
'" alt="[Image: ' +
__e(user.attributes.username ) +
']" title="' +
__e( user.attributes.full_name ) +
' (' +
__e( user.attributes.username ) +
')" class="img-rounded img-responsive avatar avatar-sm">\n';
 } else {;
__p += '\n\t<i class="avatar avatar-color-194 avatar-sm img-rounded">' +
__e( user.attributes.initials ) +
'</i>\t\t\t\t\t\t\t\t\t\n';
 } ;
__p += '\n</span> <span>' +
__e( user.attributes.full_name ) +
' (' +
__e( user.attributes.username ) +
')</span></a>\n';
 }else if(user == null && _.isUndefined(q)){ ;
__p += '\t\n<span class="small">\n\t' +
__e( i18next.t('No %s available.', { postProcess: 'sprintf', sprintf: [i18next.t('users')] }) ) +
'\n</span>\n';
 } else{ ;
__p += '\n\t' +
__e( i18next.t('Search for a person in %s by name or email address.', { postProcess: 'sprintf', sprintf: [SITE_NAME]}) ) +
'\n';
 } ;
__p += '\n';

}
return __p
};

this["JST"]["templates/user_view"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<!-- Main block start -->\n<section class="clearfix row">\n\t<div class="col-xs-12">\n\t\t<div class="clearfix">\n\t\t\t<ul class="nav nav-tabs no-bor h3">\n\t\t\t\t<li ';
 if (_.isUndefined(type) || type == 'profile') { ;
__p += 'class="active" ';
};
__p += '><a href="#/user/' +
__e(user.attributes.id) +
'/profile"  >' +
__e( i18next.t("Profile") ) +
'</a></li>\n\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "view_user_cards"}))){ ;
__p += '\n\t\t\t\t\t<li  ';
 if (!_.isUndefined(type) && type == 'cards') { ;
__p += 'class="active" ';
};
__p += '><a href="#/user/' +
__e(user.attributes.id) +
'/cards" >' +
__e( i18next.t("Cards") ) +
'</a></li>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t';
 if(authuser.user.id === page.id || authuser.user.role_id == 1) { if(!_.isEmpty(role_links.where({slug: "edit_user_details"}))){ ;
__p += '\n\t\t\t\t\t<li ';
 if (!_.isUndefined(type) && type == 'settings') { ;
__p += 'class="active" ';
};
__p += '><a href="#/user/' +
__e(user.attributes.id) +
'/settings" >' +
__e( i18next.t("Settings") ) +
'</a></li>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "view_connected_applications"}))){ ;
__p += '\n\t\t\t\t\t<li ';
 if (!_.isUndefined(type) && type == 'oauth_applications') { ;
__p += 'class="active" ';
};
__p += '><a href="#/user/' +
__e(user.attributes.id) +
'/oauth_applications" >' +
__e( i18next.t("Authorized OAuth Applications") ) +
'</a></li>\n\t\t\t\t';
 } } ;
__p += '  \n\t\t\t</ul>\n\t\t</div>\n\t\t<div class="row">\n\t\t\t<div class="tab-content">\n\t\t\t\t';
 if (!_.isEmpty(role_links.where({slug: "view_user_activities"}))) { ;
__p += '\n\t\t\t\t\t<div class="modal-body tab-pane ';
 if (_.isUndefined(type) || type == 'profile') { ;
__p += 'active';
};
__p += '" id="profile">\n\t\t\t\t\t\t<div id="js-user-activites"></div>\n\t\t\t\t\t\t<span class="btn btn-primary hide" id="js-user-activites-load-more">' +
__e( i18next.t("Load more activities") ) +
'</span>\n\t\t\t\t\t</div>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "view_user_cards"}))){ ;
__p += '\n\t\t\t\t\t<div class="modal-body tab-pane ';
 if (!_.isUndefined(type) && type == 'cards') { ;
__p += 'active';
};
__p += '" id="cards"></div>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "edit_user_details"}))){ ;
__p += '\n\t\t\t\t\t<div class="modal-body tab-pane ';
 if (!_.isUndefined(type) && type == 'settings') { ;
__p += 'active';
};
__p += '" id="settings">\n\t\t\t\t\t\t<form class="form-horizontal clearfix pull-left js-user-profile-edit" role="form" enctype="multipart/form-data" id="js-user-profile-edit">\n\t\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t\t<label for="inputFullName" class="col-sm-4 control-label">' +
__e( i18next.t("Full Name") ) +
'</label>\n\t\t\t\t\t\t\t\t<div class="col-sm-8">\n\t\t\t\t\t\t\t\t\t<input type="text" id="inputFullName" class="form-control" name="full_name" value="' +
__e( user.attributes.full_name ) +
'" maxlength="50">\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t\t<label for="AboutMe" class="col-sm-4 control-label">' +
__e( i18next.t("About Me") ) +
'</label>\n\t\t\t\t\t\t\t\t<div class="col-sm-8">\n\t\t\t\t\t\t\t\t\t<textarea class="form-control" id="AboutMe" rows="6" name="about_me">' +
__e( user.attributes.about_me ) +
'</textarea>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t';
 if(!_.isUndefined(authuser.user) && authuser.user.role_id == 1){;
__p += '\n\t\t\t\t\t\t\t\t<div class="form-group required">\n\t\t\t\t\t\t\t\t\t<label for="inputemail" class="col-sm-4 control-label">' +
__e( i18next.t("Email") ) +
'</label>\n\t\t\t\t\t\t\t\t\t<div class="col-sm-8">\n\t\t\t\t\t\t\t\t\t\t<input type="email" id="inputemail" class="form-control" name="email" value="' +
__e( user.attributes.email ) +
'" required>\n\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t<div class="form-group required">\n\t\t\t\t\t\t\t\t<label for="inputinitials" class="col-sm-4 control-label">' +
__e( i18next.t("Initials") ) +
'</label>\n\t\t\t\t\t\t\t\t<div class="col-sm-8">\n\t\t\t\t\t\t\t\t\t<input type="text" id="inputinitials" class="form-control initialism" name="initials" value="' +
__e( user.attributes.initials.toUpperCase() ) +
'" maxlength="2" required>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div class="form-group required">\n\t\t\t\t\t\t\t\t<label for="inputtimezone" class="col-sm-4 control-label">' +
__e( i18next.t("Timezone") ) +
'</label>\n\t\t\t\t\t\t\t\t<div class="col-sm-8">\n\t\t\t\t\t\t\t\t\t<input type="text" id="inputtimezone" class="form-control initialism" name="timezone" value="' +
__e( user.attributes.timezone ) +
'" required>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t\t<label for="is_send_newsletter" class="col-sm-4 control-label">' +
__e( i18next.t("Notifications") ) +
'</label>\n\t\t\t\t\t\t\t\t<div class="col-sm-8">\n\t\t\t\t\t\t\t\t\t<select  id="is_send_newsletter" class="js-chosen-select" name="is_send_newsletter">\n\t\t\t\t\t\t\t\t\t\t<option value="0">' +
__e( i18next.t("Never, Don't send email notifications") ) +
'</option>\n\t\t\t\t\t\t\t\t\t\t<option value="1">' +
__e( i18next.t("Periodically, Send email notification every 1 hour") ) +
'</option>\n\t\t\t\t\t\t\t\t\t\t<option value="2">' +
__e( i18next.t("Instantly, Send email notification every 5 minutes") ) +
'</option>\n\t\t\t\t\t\t\t\t\t</select>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "add_user_profile_picture"}))){ ;
__p += '\n\t\t\t\t\t\t\t\t<div class="form-group" id="dropzone">\n\t\t\t\t\t\t\t\t\t<label for="inputAttachment" class="col-sm-4 control-label sr-only">' +
__e( i18next.t("Upload Avatar") ) +
'</label>\n\t\t\t\t\t\t\t\t\t<div class="col-xs-8">\n\t\t\t\t\t\t\t\t\t\t<a data-placement="bottom" title="' +
__e( user.attributes.username) +
'" data-toggle="tooltip" href="#" class="avatar-option js-use-uploaded-avatar drag-box navbar-left"> \n\t\t\t\t\t\t\t\t\t\t\t';
 if(!_.isEmpty(user.attributes.profile_picture_path) && user.attributes.profile_picture_path != 'NULL') { 
												var profile_picture_path = user.showImage('User', user.attributes.id, 'small_thumb' ) +'?'+ new Date().getTime();
											;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t<span class="js-remove-image  profile-block show"><i class="icon icon-remove close-block cur h6"></i></span>\n\t\t\t\t\t\t\t\t\t\t\t\t<img src="' +
__e( profile_picture_path ) +
'" width="50" height="50" class="js-user-avatar">\n\t\t\t\t\t\t\t\t\t\t\t';
 } else {;
__p += '\n\t\t\t\t\t\t\t\t\t\t\t\t<i class="avatar avatar-color-194 avatar-md img-rounded">' +
__e( user.attributes.initials ) +
'</i>\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t\t\t\t<span class="clearfix navbar-btn"><span id="dropzone-cssloader" ></span></span>\n\t\t\t\t\t\t\t\t  <div class="clearfix" id="manager-area"></div>\n\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t</span>\n\t\t\t\t\t\t\t\t</span>\n\t\t\t\t\t\t\t';
 } ;
__p += '\n\t\t\t\t\t\t\t<div class="col-xs-9 pull-right clearfix">\n\t\t\t\t\t\t\t\t<div class="form-group">\n\t\t\t\t\t\t\t\t\t<label for="submit2" class="col-sm-1 control-label sr-only">' +
__e( i18next.t("Submit") ) +
'</label>\n\t\t\t\t\t\t\t\t\t<input type="submit" value="' +
__e( i18next.t('Submit') ) +
'" id="submit2" class="btn btn-primary btn-lg">\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t</form>\n\t\t\t\t\t</div>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t\t';
 if(!_.isEmpty(role_links.where({slug: "view_connected_applications"}))){ ;
__p += '\n\t\t\t\t\t<div class="modal-body tab-pane ';
 if (!_.isUndefined(type) && type == 'oauth_applications') { ;
__p += 'active';
};
__p += '" id="oauth_applications">\n\t\t\t\t\t</div>\n\t\t\t\t';
 } ;
__p += '\n\t\t\t</div>\n\t\t</div>\n\t</div>\n</section>\n<!-- Main block end -->';

}
return __p
};

this["JST"]["templates/user_view_header"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div id="js-navbar-default" class="navbar navbar-default" role="navigation">\n  <div class="container-fluid">\n\t<div class="navbar-left navbar-btn">\n\t  <div class="clearfix navbar-btn">\n\t\t<h2 class="pull-left navbar-btn"><span class="pull-left"><a href="#/" title="' +
__e( SITE_NAME ) +
'"><img src="img/logo.png" alt="[Image: ' +
__e( SITE_NAME ) +
']" title="' +
__e( SITE_NAME ) +
'" class="img-responsive center-block"/></a></span></h2>\n\t\t<ul class="list-inline pull-left h3 navbar-btn navbar-form">\n\t\t\t <li class="navbar-btn text-muted"><span class="h5">/</span></li>\n\t\t\t<li><span class="text-muted h4">' +
__e( user.attributes.full_name ) +
' (' +
__e( user.attributes.username ) +
')</span></li>\n\t\t</ul>\n\t  </div>\n\t</div>\n  </div>\n</div>';

}
return __p
};

this["JST"]["templates/users_forgot_password"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape;
with (obj) {
__p += '<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 col-lg-offset-4 col-md-offset-4 col-sm-offset-3">\n<div class="panel panel-default">\n  <div class="panel-heading lead list-group-item-text">' +
__e( i18next.t("Forgot your password") ) +
'?</div>\n  <div class="panel-body well-lg">\n\t<div class="alert alert-info">' +
__e( i18next.t("Enter your email and we will send new password.") ) +
'</div>\n\t<form id="UserForgotPasswordForm" name="UserForgotPasswordForm" class="form-horizontal col-xs-12">\n\t  <div class="form-group required">\n\t\t<label class="sr-only control-label" for="inputEmail">' +
__e( i18next.t("Email") ) +
'</label>\n\t\t<input type="email" name="email" id="inputEmail" class="form-control" placeholder="' +
__e( i18next.t('Email') ) +
'" title="' +
__e( i18next.t('Email') ) +
'" required>\n\t  </div>\n\t  <div class="form-group">\n\t\t<label class="sr-only control-label" for="submit2">' +
__e( i18next.t("Send") ) +
' </label>\n\t\t<input type="submit" class="btn btn-primary col-xs-12" id="submitForgotPassword" value="' +
__e( i18next.t('Send') ) +
'">\n\t  </div>\n\t</form>\n  </div>\n</div>\n</div>';

}
return __p
};

this["JST"]["templates/users_register"] = function(obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 col-lg-offset-4 col-md-offset-4 col-sm-offset-3">\n<div class="panel panel-default">\n  <div class="panel-heading lead">' +
__e( i18next.t("Register") ) +
'</div>\n  <div class="panel-body well-lg">\n\t<form id="UserRegisterForm" name="UserRegisterForm" class="form-horizontal col-xs-12">\n\t  <div class="form-group required">\n\t\t<label class="sr-only control-label" for="inputEmail">' +
__e( i18next.t("Email") ) +
'</label>\n\t\t<input type="email" required name="email" id="inputEmail" class="form-control" placeholder="' +
__e( i18next.t('Email') ) +
'" title="' +
__e( i18next.t('Email') ) +
'">\n\t  </div>\n\t  <div class="form-group required">\n\t\t<label class="sr-only control-label" for="inputUsername">' +
__e( i18next.t("Username") ) +
'</label>\n\t\t<input type="name" name="username" id="inputUsername" class="form-control" placeholder="' +
__e( i18next.t('Username') ) +
'" required pattern=".{3,15}" title="' +
__e( i18next.t('Username. Minimum 3 characters') ) +
'">\n\t  </div>\n\t  <div class="form-group required">\n\t\t<label class="sr-only control-label" for="inputPassword">' +
__e( i18next.t("Password") ) +
'</label>\n\t\t<input type="password" required name="password" id="inputPassword"class="form-control" placeholder="' +
__e( i18next.t('Password') ) +
'" pattern="[A-Za-z0-9\\S]{6,50}" title="' +
__e( i18next.t('Password. Minimum 6 characters and white space not allowed') ) +
'">\n\t  </div>\n\t  <div class="form-group">\n\t\t<label class="sr-only ontrol-label" for="submitRegister">' +
__e( i18next.t("Join Now") ) +
'</label>\n\t\t<input type="submit" class="btn btn-primary col-xs-12" id="submitRegister" value="' +
__e( i18next.t('Join Now') ) +
'">\n\t  </div>\n\t  <ul class="list-inline small text-center">\n\t\t  ';
 if(!_.isEmpty(role_links.where({slug: "users_forgotpassword"}))){ ;
__p += '\n\t\t  \t<li><a href="#/users/forgotpassword" title="' +
__e( i18next.t('Forgot your password') ) +
'?" class="text-primary">' +
__e( i18next.t("Forgot your password") ) +
'?</a></li>\n\t\t\t';
 };
__p += '\n\t\t</ul>\n\t</form>\n  </div>\n</div>\n</div>';

}
return __p
};