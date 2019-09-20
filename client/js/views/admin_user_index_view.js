/**
 * @fileOverview This file has functions related to user view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Admin User Index View
 * @class AdminUserIndexView
 * @constructor
 * @extends Backbone.View
 */
App.AdminUserIndexView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(options.page) && options.page !== null) {
            var page_no;
            if (options.page.indexOf('filter') !== -1) {
                var query_param = options.page.split('&filter=');
                page_no = query_param[0].replace('page=', '');
                this.current_page = page_no + '&filter=' + query_param[1];
                if (query_param[1].indexOf('&sort=') !== -1) {
                    var filter_page = query_param[1].split('&sort=');
                    query_param[1] = filter_page[0];
                }
                this.current_param = query_param[1];
            } else {
                page_no = options.page.split('page=');
                this.current_page = page_no[1];
                this.current_param = 'all';
            }
        } else {
            this.current_page = 1;
            this.current_param = 'all';
        }
        this.render();
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.updateCollection();
    },
    updateCollection: function() {
        var _this = this;
        if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_groups', APPS.enabled_apps) !== -1) {
            $.ajax({
                url: api_url + 'groups.json?limit=10000&token=' + this.getToken() + '&sort=name&direction=asc',
                cache: false,
                type: 'GET',
                success: function(response) {
                    _this.overall_groups = [];
                    if (response.data) {
                        _this.overall_groups = response.data;
                    }
                }
            });
        }
        _this.current_page = (!_.isUndefined(_this.current_page)) ? _this.current_page : 1;
        _this.pagination = (!_.isUndefined(_this.pagination)) ? _this.pagination : 1;
        _this.users = new App.UserCollection();
        var colspan = "15";
        if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_groups', APPS.enabled_apps) !== -1) {
            colspan = "16";
        }
        $('.js-user-list').html('<tr class="js-loader"><td colspan="' + colspan + '"><span class="cssloader"></span></td></tr>');
        _this.users.url = api_url + 'users.json?page=' + _this.current_page;
        _this.users.fetch({
            cache: false,
            abortPending: true,
            success: function(users, response) {
                _this.headerView = new App.HeaderView({
                    model: authuser,
                    users: users
                });
                $('#header').html(_this.headerView.el);
                $('#js-navbar-default').remove();
                if (_this.current_param.indexOf('&sort=') !== -1) {
                    var filter_page = _this.current_param.split('&sort=');
                    _this.current_param = filter_page[0];
                }
                $('#content').html(new App.UserIndexContainerView({
                    filter_count: response.filter_count,
                    roles: response.roles,
                    'current_param': _this.current_param
                }).el);
                users.each(function(user) {
                    user.roles = response.roles;
                    user.overall_groups = _this.overall_groups;
                    $('.js-user-list').append(new App.UserIndex({
                        model: user
                    }).el);
                });
                $('.pagination-boxes').unbind();
                $('.pagination-boxes').html('');
                if (!_.isUndefined(response._metadata) && parseInt(response._metadata.noOfPages) > 1) {
                    $('.pagination-boxes').pagination({
                        total_pages: parseInt(response._metadata.noOfPages),
                        current_page: parseInt(_this.current_page),
                        display_max: 4,
                        callback: function(event, page) {
                            event.preventDefault();
                            if (page) {
                                _this.pagination = 2;
                                if (!_.isUndefined(_this.current_param) && _this.current_param !== null && _this.current_param !== 'all') {
                                    _this.current_page = page + '&filter=' + _this.current_param;
                                    page = _this.current_page;
                                } else if (!_.isUndefined(_this.current_param) && _this.current_param !== null && _this.current_param === 'all' && typeof _this.current_page === 'string') {
                                    var current_page = _this.current_page.split('&sort=');
                                    _this.current_page = page + '&sort=' + current_page['1'];
                                    page = _this.current_page;
                                } else {
                                    _this.current_page = page;
                                }
                                app.navigate('#/' + 'users?page=' + page, {
                                    trigger: false,
                                    trigger_function: false,
                                });
                                _this.updateCollection();
                            }
                        }
                    });
                }
            }
        });
    },
    getToken: function() {
        if ($.cookie('auth') !== undefined) {
            var Auth = JSON.parse($.cookie('auth'));
            api_token = Auth.access_token;
            return api_token;
        } else {
            return false;
        }
    }
});
