$(window).resize(function() {
    var headerH = $("header").height();
    var footerH = $("footer").height();
    var windowH = $(window).height();
    var notificationH = windowH - footerH;
    var boardH = footerH ? (windowH - headerH - footerH - 14) : (boardH = windowH - headerH - 50);
    $(".board-list-view").css("height", (boardH + 'px'));
    if ($(".js-board-list") && (/Edge/.test(navigator.userAgent) || !!navigator.userAgent.match(/Trident.*rv\:11\./))) {
        $(".js-board-list").css("height", (boardH + 'px'));
    }
    $(".notification-list").css({
        'height': notificationH - 100,
        'overflow-y': 'scroll'
    });
    $('.member-modal.js-pre-scrollable').css({
        'max-height': boardH - 50,
        'overflow-y': 'auto'
    });
});

function changeTitle(title, Iscardview) {
    var title_format = (Iscardview === true) ? "%s | %s's Restyaboard" : "%s's Restyaboard | %s";
    var title_content = (Iscardview === true) ? [title, SITE_NAME] : [SITE_NAME, title];
    if (title !== undefined) {
        document.title = i18next.t(title_format, {
            postProcess: 'sprintf',
            sprintf: title_content
        });
    }
}

function appPageCallBack(e) {
    appManage(e);
}

function checkKeycode(keycode, c) {
    for (var b = 0, d = keycode.length; b < d; b++)
        if (b in keycode && keycode[b] === c) return b;
    return -1;
}

function makeLink(text, board_id) {
    text = text.replace(/#(\d+)/g, '<a class="js-open-card-view" data-card_id="$1" href="#/board/' + board_id + '/card/$1">#$1</a>');
    if (!_.isUndefined(APPS) && APPS !== null) {
        if (!_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) {
            if ($.inArray('r_wiki', APPS.enabled_apps) !== -1) {
                text = text.replace(/%(\d+)/g, '<a class="js-open-wiki-view" target="_blank" data-card_id="$1" href="#/apps/r_wiki/pages?id=$1">%$1</a>');
            }
        }
    }

    text = text.replace(/(?!\b)(@\w+\b)/g, '<span class="atMention">$1</span>');
    return text;
}

function CheckFieldExists(board, field_name, field_value, return_type, plugin_name) {
    var checked_value = (return_type === 'Value') ? field_value : true;
    if (!_.isUndefined(APPS) && APPS !== null) {
        if (!_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) {
            if ($.inArray(plugin_name, APPS.enabled_apps) !== -1) {
                if (!_.isUndefined(board) && !_.isEmpty(board) && !_.isUndefined(board.attributes) && !_.isEmpty(board.attributes) && !_.isUndefined(board.attributes.board_custom_fields) && !_.isEmpty(board.attributes.board_custom_fields)) {
                    board_custom_fields = JSON.parse(board.attributes.board_custom_fields);
                    if (!_.isUndefined(board_custom_fields[plugin_name])) {
                        r_gridview_configurations = board_custom_fields[plugin_name].split(',');
                        if (r_gridview_configurations.length > 0) {
                            if (r_gridview_configurations.indexOf(field_name) !== -1 || r_gridview_configurations.indexOf('selectall') !== -1) {
                                checked_value = (return_type === 'Value') ? field_value : true;
                            } else {
                                checked_value = (return_type === 'Value') ? '' : false;
                            }
                        } else {
                            checked_value = (return_type === 'Value') ? '' : false;
                        }
                    }
                }
            }
        }
    }
    return checked_value;
}

function CheckFieldPermission(board, board_user_role_id, permission) {
    var checked_permission = false;
    if (!_.isUndefined(authuser) && !_.isUndefined(authuser.user) && !_.isUndefined(board) && !_.isEmpty(board) && (authuser.user.role_id == 1 || (!_.isUndefined(board.acl_links) && !_.isEmpty(board.acl_links)))) {
        if (authuser.user.role_id == 1) {
            checked_permission = true;
        } else if (!_.isEmpty(board.acl_links.where({
                slug: permission,
                board_user_role_id: parseInt(board_user_role_id)
            }))) {
            checked_permission = true;
        }
    }
    return checked_permission;
}

function activityCommentReplace(activity) {
    if (!_.isUndefined(activity.comment) && !_.isEmpty(activity.comment)) {
        activity.comment = activity.comment.replace("the card ##CARD_LINK##", "this card");
    }
    return activity;
}
var favicon = new Favico({
    animation: 'popFade'
});

function parse_date(dateTime, logged_user, classname, isAbbrReturn) {
    var s = dateTime.replace("T", " "),
        current_timezone;
    new_date = moment.tz(s, 'YYYY-MM-DD HH:mm:ss', SITE_TIMEZONE).utc().format('YYYY-MM-DD HH:mm:ss');
    if (logged_user && logged_user.user && !_.isUndefined(logged_user.user.timezone) && !_.isEmpty(logged_user.user.timezone) && logged_user.user.timezone !== null) {
        current_timezone = moment.tz(logged_user.user.timezone).format('Z').replace(':', '');
    } else {
        current_timezone = moment.tz(SITE_TIMEZONE).format('Z').replace(':', '');
    }
    tz = moment(new_date + ' Z').utcOffset(current_timezone).format('YYYY-MM-DD HH:mm:ss');
    if (!moment.isMoment(tz)) {
        tz = moment(tz);
    }
    var timestr = '<abbr title="' + tz.format() + '">' + tz.fromNow() + '</abbr>';
    if (isAbbrReturn !== undefined) {
        return timestr;
    } else {
        $('.' + classname).html(timestr);
        return true;
    }
}

function stripScripts(s) {
    var div = document.createElement('div');
    div.innerHTML = s;
    var scripts = div.getElementsByTagName('script');
    var i = scripts.length;
    while (i--) {
        scripts[i].parentNode.removeChild(scripts[i]);
    }
    return div.innerHTML;
}
