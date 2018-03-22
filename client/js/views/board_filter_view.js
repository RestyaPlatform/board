/**
 * @fileOverview This file has functions related to board filter view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. It contain all board based object @see Available Object in App.BoardView
 *	this.model.labels				: labels collection
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardFilter View
 * @class BoardFilterView
 * @constructor
 * @extends Backbone.View
 */
App.BoardFilterView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.labels = options.labels;
        this.render();
    },
    template: JST['templates/board_filter'],
    tagName: 'li',
    className: 'js-open-dropdown',
    converter: new showdown.Converter({
        extensions: ['targetblank', 'xssfilter', 'codehighlight']
    }),
    /** 
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'keyup .js-filter-cards': 'showFilteredCards'
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.converter.setFlavor('github');
        this.$el.html(this.template({
            board: this.model,
            board_labels: this.labels,
            converter: this.converter
        }));
        this.showTooltip();
        this.filterBoard();
        return this;
    },
    showFilteredCards: function(e) {
        console.log('SHOW_FILTERED_CARDS');
        e.preventDefault();
        var self = this;
        var el = this.$el;
        el.find('.js-board-labels').html('');
        el.find('.js-board-users').html('');
        var search_value = $(e.currentTarget).val();
        var filteredLabels;
        var filteredUsers;
        filteredLabels = this.model.labels.filter(function(label) {
            if (label.attributes.name.toUpperCase().indexOf(search_value.toUpperCase()) != -1) {
                return label;
            }
        });
        filteredUsers = this.model.board_users.filter(function(user) {
            if (user.attributes.username.toUpperCase().indexOf(search_value.toUpperCase()) != -1) {
                return user;
            }
        });
        if (!_.isEmpty(filteredLabels) && !_.isUndefined(filteredLabels)) {
            var string = '';
            var labels = Array();
            _.each(filteredLabels, function(label) {
                if (!_.contains(labels, label.attributes.name)) {
                    labels.push(label.attributes.name);
                    var labelColor = (label.attributes.color) ? label.attributes.color : '#' + self.converter.colorCode(label.attributes.name).substring(0, 6);
                    string += '<li class="clearfix js-toggle-label-filter cur card-label-show h5 btn-link media"><span style="background:' + labelColor + ';color:#ffffff" class="pull-left btn btn-xs"><i class="' + LABEL_ICON + ' icon-light"></i></span><div class="htruncate js-label">' + label.attributes.name + '</div></li>';
                }
            });
            self.$el.find('.js-board-labels').append(string);
        }
        if (!_.isEmpty(filteredUsers) && !_.isUndefined(filteredUsers)) {
            var Userstring = '';
            var users = Array();
            _.each(filteredUsers, function(user) {
                var image_content = '<i class="avatar avatar-color-194 img-rounded" title="' + user.attributes.username + '">' + user.attributes.initials + '</i>';
                if (!_.isEmpty(user.attributes.profile_picture_path)) {
                    var profile_picture_path = user.showImage('User', user.attributes.user_id, 'small_thumb');
                    image_content = '<img class="img-rounded img-responsive" src="' + profile_picture_path + '" alt="[Images: ' + user.attributes.username + ']" title="' + user.attributes.username + '" />';
                }
                Userstring += '<li class="clearfix js-toggle-label-filter cur card-label-show h5 btn-link"><div class="navbar-btn clearfix media"><span class="pull-left">' + image_content + '</span><span data-user = "' + user.attributes.username + '" class="pull-left navbar-btn htruncate">' + user.attributes.username + '<span class="js-user hide">user-filter-' + user.attributes.user_id + '</span></div></li>';
            });
            self.$el.find('.js-board-users').append(Userstring);
        }
    },
    /**
     * filterBoard()
     * toggle board filter list
     * @param e
     * @type Object(DOM event)
     *
     */
    filterBoard: function(e) {
        console.log('FILTER_BOARD');
        var self = this;
        this.$el.find('.js-clear-filter-btn').removeClass('hide').addClass('show');
        var filter_label_arr = [],
            filter_user_arr = [],
            filter_due_arr = [];
        var filter_mode;
        var current_param = Backbone.history.fragment.split('?');
        var current_url = current_param[0].split('/');
        var filter = 'grid';
        if (current_url.length === 3 && current_url[2] == 'list') {
            filter = 'list';
        } else if (current_url.length === 3 && current_url[2] == 'gantt') {
            filter = 'gantt';
        }
        if (current_param[1]) {
            this.$el.find('.js-clear-all').removeClass('text-muted');
            var query_params = current_param[1].split(',');
            query_params[0] = query_params[0].replace('filter=', '');
            $.each(query_params, function(index, value) {
                if (value.indexOf('label:') > -1) {
                    filter_label_arr.push(value.replace('label:', ''));
                } else if (value.indexOf('@') > -1) {
                    filter_user_arr.push(value.replace('@', ''));
                } else if (value.indexOf('due:') > -1) {
                    filter_due_arr.push(value.replace('due:', ''));
                } else if (value.indexOf('mode:') > -1) {
                    var mode = value.replace('mode:', '');
                    if (mode === 'and') {
                        filter_mode = 'and';
                    }
                }
            });
            /* jshint ignore:start */
            if (!_.isEmpty(filter_label_arr)) {
                for (i = 0; i < filter_label_arr.length; i++) {
                    self.$el.find('.js-board-labels > li').each(function(index) {
                        if (($(this).find('.js-label').text() === filter_label_arr[i]) && ($(this).find('.js-label').next('i').length === 0)) {
                            $(this).append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
                            $(this).addClass('selected');
                        }
                    });
                }
            }
            if (!_.isEmpty(filter_user_arr)) {
                for (i = 0; i < filter_user_arr.length; i++) {
                    self.$el.find('.js-board-users > li').each(function(index) {
                        if (($(this).find('.js-user').parent().data('user') === filter_user_arr[i]) && ($(this).find('.js-user').next('i').length === 0)) {
                            $(this).find('.media').append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
                            $(this).addClass('selected');
                        }
                    });
                }
            }
            if (!_.isEmpty(filter_due_arr)) {
                for (i = 0; i < filter_due_arr.length; i++) {
                    self.$el.find('.js-board-dues > li').each(function(index) {
                        if (($(this).find('.js-due').text() === filter_due_arr[i]) && ($(this).find('.js-due').next('i').length === 0)) {
                            $(this).append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
                            $(this).addClass('selected');
                        }
                    });
                }
            }
            if (!_.isEmpty(filter_mode)) {
                _(function() {
                    if ($('ul.js-filter-conjunction > li#js-mode-or > i.js-filter_mode-icon').length === 1) {
                        $('li#js-mode-or > i.js-filter_mode-icon').remove();
                    }
                }).defer();
                self.$el.find('.js-filter-conjunction > li#js-mode-and').each(function(index) {
                    if (($(this).find('.js-filter').text() === 'and') && ($(this).find('.js-filter').next('i').length === 0)) {
                        $(this).append('<i class="icon-ok js-filter_mode-icon cur pull-right"></i>');
                        $(this).addClass('selected');
                    }
                });
            }
            /* jshint ignore:end */
        }
    }
});
