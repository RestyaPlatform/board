"use strict";

// TODO simplify
function filter_getFilterObject(current_param, cardModels) {
    var filter_label_arr = [],
        filter_user_arr = [],
        filter_due_arr = [];
    var filter_mode;
    var current_url = current_param[0].split('/');
    var filter_query = '';

    var filter = 'grid';

    if (current_url.length === 3 && current_url[2] === 'list') {
        filter = 'list';
    } else if (current_url.length === 3 && current_url[2] === 'gantt') {
        filter = 'gantt';
    }

    $('li.selected > div.js-label', $('ul.js-board-labels')).each(function () {
        filter_label_arr.push($(this).html());
        filter_query += 'label:' + $(this).html() + ',';
        if ($(this).next('i').length === 0) {
            $(this).after('<i class="icon-ok js-filter-icon cur pull-right"></i>');
        }
    });

    $('li.selected > div.media > span.navbar-btn > span.js-user', $('ul.js-board-users')).each(function () {
        filter_user_arr.push($(this).parent().data('user'));
        filter_query += '@' + $(this).parent().data('user') + ',';
        if ($(this).next('i').length === 0) {
            $(this).parent().parent().append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
        }
    });

    $('li.selected > div.media > span.js-due', $('ul.js-board-dues')).each(function () {
        filter_due_arr.push($(this).html());
        filter_query += 'due:' + $(this).html() + ',';
        if ($(this).next('i').length === 0) {
            $(this).parent().parent().append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
        }
    });

    $('li.selected > div.media > span.js-filter', $('ul.js-filter-conjunction')).each(function () {
        var $mode_and_icon = $('li#js-mode-and > i.js-filter_mode-icon');
        var $mode_or_icon = $('li#js-mode-or > i.js-filter_mode-icon');

        if ($(this).html() === 'or') {
            if ($mode_and_icon.length === 1) {
                $mode_and_icon.remove();
            }
            if ($mode_or_icon.length === 0) {
                $('li#js-mode-or').append('<i class="icon-ok js-filter_mode-icon cur pull-right"></i>');
            }
        }
        if ($(this).html() === 'and') {
            filter_mode = 'and';
            if (filter_query) {
                filter_query += 'mode:' + $(this).html() + ',';
            }
            if ($mode_or_icon.length === 1) {
                $mode_or_icon.remove();
            }
            if ($mode_and_icon.length === 0) {
                $('li#js-mode-and').append('<i class="icon-ok js-filter_mode-icon cur pull-right"></i>');
            }
        }
    });

    var show_label_arr = [];
    var result_label_arr = [];

    if (!_.isEmpty(filter_label_arr)) {
        $('ul.js-card-labels li').filter(function (index) {
            index = $.inArray($(this).text(), filter_label_arr);
            if (index !== -1) {
                if (_.isUndefined(show_label_arr[index])) {
                    show_label_arr[index] = [];
                }
                if (filter === 'list') {
                    show_label_arr[index].push($(this).parent().parent().attr('id'));
                    /*show_label_arr[index].push($(this).parent().parent().find('div').attr('id'));*/
                } else {
                    show_label_arr[index].push($(this).parent().parent().attr('id'));
                }
            }
        });
        if (filter_label_arr.length !== show_label_arr.length) {
            show_label_arr = [];
        }
    }

    if (!_.isEmpty(filter_mode)) {
        if (filter_mode === 'and') {
            if (!_.isEmpty(show_label_arr)) {
                result_label_arr = show_label_arr.shift().filter(function (v) {
                    return show_label_arr.every(function (a) {
                        return a.indexOf(v) !== -1;
                    });
                });
            }
        }
    } else if (!_.isEmpty(show_label_arr)) {
        result_label_arr = _.union.apply(_, show_label_arr);
    }

    var show_user_arr = [];
    var result_user_arr = [];

    if (!_.isEmpty(filter_user_arr)) {
        $('ul.js-card-users li').filter(function (index) {
            index = $.inArray($(this).text(), filter_user_arr);
            if (index !== -1) {
                if (_.isUndefined(show_user_arr[index])) {
                    show_user_arr[index] = [];
                }
                if (filter === 'list') {
                    /*show_user_arr[index].push($(this).parent().parent().find('div').attr('id'));*/
                    show_user_arr[index].push($(this).parent().parent().attr('id'));
                } else {
                    show_user_arr[index].push($(this).parent().parent().attr('id'));
                }
            }
        });

        if (filter_user_arr.length !== show_user_arr.length) {
            show_user_arr = [];
        }
    }
    if (!_.isEmpty(filter_mode)) {
        if (filter_mode === 'and') {
            if (!_.isEmpty(show_user_arr)) {
                result_user_arr = show_user_arr.shift().filter(function (v) {
                    return show_user_arr.every(function (a) {
                        return a.indexOf(v) !== -1;
                    });
                });
            }
        }
    } else if (!_.isEmpty(show_user_arr)) {
        result_user_arr = _.union.apply(_, show_user_arr);
    }

    var show_due_arr = [];
    var result_due_arr = [];

    if (!_.isEmpty(filter_due_arr)) {
        cardModels.each(function(card) {
            var conditionBroke = filter_dueConditionBroke(card, filter_due_arr);
            if (!conditionBroke) {
                result_due_arr.push(card.get('id'));
            }
        });
    }

    var arrays = [];

    // TODO what is with concatenated filtering like: overdue + admin-user?
    if (!_.isEmpty(filter_label_arr)) {
        arrays.push(result_label_arr);
    }
    if (!_.isEmpty(filter_user_arr)) {
        arrays.push(result_user_arr);
    }
    if (!_.isEmpty(filter_due_arr)) {
        arrays.push(result_due_arr);
    }

    return {
        arrays: _.filter(arrays, function (val) {
            if (!_.isArray(val)) {
                return false;
            }
            return !_.isEmpty(val[0]);
        }),
        filter: filter,
        filter_query: filter_query
    };
}

// TODO keep track of filter mode not via classes in CSS. Use some store/state
function filter_applySelectedClassToSidebarItems($li_item) {
    if ($li_item.parent().hasClass('js-filter-conjunction')) {
        if ($li_item.attr('id') === 'js-mode-or') {
            if (!$($li_item).hasClass('selected')) {
                $($li_item).addClass('selected');
            }
            var $li_and = $('li#js-mode-and');
            if ($li_and.hasClass('selected')) {
                $li_and.removeClass('selected');
            }
        }
        if ($li_item.attr('id') === 'js-mode-and') {
            if (!$($li_item).hasClass('selected')) {
                $($li_item).addClass('selected');
            }
            var $li_or = $('li#js-mode-or');
            if ($li_or.hasClass('selected')) {
                $li_or.removeClass('selected');
            }
        }
    } else {
        $li_item.toggleClass('selected', !$li_item.hasClass('selected'));
    }
}

/**
 * Iterates the card model and checks if all due conditions are fulfilled. If one is not fulfilled -> return true
 * @param cardModel
 * @param dueValueArray
 * @returns {boolean} True if any condition broke else false.
 */
function filter_dueConditionBroke(cardModel, dueValueArray) {
    if (!cardModel.get("due_date")) {
        // No due date set -> Condition broke
        return true;
    }

    var dueMoment = moment(cardModel.get("due_date"));
    var now = moment();
    var dueConditionBroke = false;

    for (var i = 0; i < dueValueArray.length; i++) {
        var dueValue = dueValueArray[i];

        switch(dueValue) {
            case "overdue":
                dueConditionBroke = !dueMoment.isBefore(now, "minutes");
                break;
            case "day":
                dueConditionBroke = dueMoment.diff(now, "days") < 1;
                break;
            case "week":
                dueConditionBroke = dueMoment.diff(now, "weeks") < 1;
                break;
            case "month":
                dueConditionBroke = dueMoment.diff(now, "months") < 1;
                break;
        }

        if (dueConditionBroke) {
            // Condition broke -> Stop
            break;
        }
    }

    return dueConditionBroke;
}
