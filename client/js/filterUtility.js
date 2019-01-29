function filter_getFilterObject(current_param, cardModels) {
    var filter_label_arr = [],
        filter_user_arr = [],
        filter_color_arr = [],
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

    $('li.selected > div.js-label', $('ul.js-board-labels')).each(function() {
        filter_label_arr.push($(this).html());
        filter_query += 'label:' + $(this).html() + ',';
        if ($(this).next('i').length === 0) {
            $(this).after('<i class="icon-ok js-filter-icon cur pull-right"></i>');
        }
    });

    $('li.selected > div.media > span.navbar-btn > span.js-user', $('ul.js-board-users')).each(function() {
        filter_user_arr.push($(this).parent().data('user'));
        filter_query += '@' + $(this).parent().data('user') + ',';
        if ($(this).next('i').length === 0) {
            $(this).parent().parent().append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
        }
    });

    $('li.selected', $('ul.js-board-colors')).each(function() {
        filter_color_arr.push($(this).data('color'));
        filter_query += 'color:' + $(this).data('color') + ',';
        if ($(this).next('i').length === 0) {
            $(this).prepend('<i class="icon-ok js-filter-icon cur pull-right card-color"></i>');
        }
    });

    $('li.selected > div.media > span.js-due', $('ul.js-board-dues')).each(function() {
        filter_due_arr.push($(this).html());
        filter_query += 'due:' + $(this).html() + ',';
        if ($(this).next('i').length === 0) {
            $(this).parent().parent().append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
        }
    });

    $('li.selected > div.media > span.js-filter', $('ul.js-filter-conjunction')).each(function() {
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
        $('ul.js-card-labels li').filter(function(index) {
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
                result_label_arr = show_label_arr.shift().filter(function(v) {
                    return show_label_arr.every(function(a) {
                        return a.indexOf(v) !== -1;
                    });
                });
            }
        }
    } else if (!_.isEmpty(show_label_arr)) {
        result_label_arr = _.union.apply(_, show_label_arr);
    }

    var show_color_arr = [],
        result_color_arr = [];
    if (!_.isEmpty(filter_color_arr)) {
        $('ul.js-card-colors li').filter(function(index) {
            index = $.inArray($(this).text(), filter_color_arr);
            if (index !== -1) {
                if (_.isUndefined(show_color_arr[index])) {
                    show_color_arr[index] = [];
                }
                if (filter == 'list') {
                    show_color_arr[index].push($(this).parent().parent().attr('id'));
                } else {
                    show_color_arr[index].push($(this).parent().parent().attr('id'));
                }
            }
        });
    }
    if (!_.isEmpty(filter_mode)) {
        if (filter_mode === 'and') {
            if (!_.isEmpty(show_color_arr)) {
                result_color_arr = show_color_arr.shift().filter(function(v) {
                    return show_color_arr.every(function(a) {
                        return a.indexOf(v) !== -1;
                    });
                });
            }
        }
    } else if (!_.isEmpty(show_color_arr)) {
        result_color_arr = _.union.apply(_, show_color_arr);
    }

    var show_user_arr = [];
    var result_user_arr = [];

    if (!_.isEmpty(filter_user_arr)) {
        $('ul.js-card-users li').filter(function(index) {
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
                result_user_arr = show_user_arr.shift().filter(function(v) {
                    return show_user_arr.every(function(a) {
                        return a.indexOf(v) !== -1;
                    });
                });
            }
        }
    } else if (!_.isEmpty(show_user_arr)) {
        result_user_arr = _.union.apply(_, show_user_arr);
    }


    var show_due_arr = [],
        result_due_arr = [];
    if (!_.isEmpty(filter_due_arr)) {
        $('ul.js-card-due li').filter(function(index) {
            index = $.inArray($(this).text(), filter_due_arr);
            if (index !== -1) {
                if (_.isUndefined(show_due_arr[index])) {
                    show_due_arr[index] = [];
                }
                if (filter == 'list') {
                    /*show_due_arr[index].push($(this).parent().parent().find('div').attr('id'));*/
                    show_due_arr[index].push($(this).parent().parent().attr('id'));
                } else {
                    show_due_arr[index].push($(this).parent().parent().attr('id'));
                }
            }
        });
        if (filter_due_arr.length != show_due_arr.length) {
            show_due_arr = [];
        }
    }
    if (!_.isEmpty(show_due_arr)) {
        var due_arr = [];
        $.each(show_due_arr, function(index, value) {
            if (value !== undefined) {
                due_arr.push(value);
            }
        });
        result_due_arr = due_arr.shift().filter(function(v) {
            return due_arr.every(function(a) {
                return a.indexOf(v) !== -1;
            });
        });
    }

    var arrays = [];

    if (!_.isEmpty(filter_label_arr)) {
        arrays.push(result_label_arr);
    }
    if (!_.isEmpty(filter_color_arr)) {
        arrays.push(result_color_arr);
    }
    if (!_.isEmpty(filter_user_arr)) {
        arrays.push(result_user_arr);
    }
    if (!_.isEmpty(filter_due_arr)) {
        arrays.push(result_due_arr);
    }

    return {
        arrays: arrays,
        filter_query: filter_query
    };
}
