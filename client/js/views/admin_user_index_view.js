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
        if (!_.isUndefined(APPS) && APPS !== null) {
            if (!_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) {
                if ($.inArray('r_groups', APPS.enabled_apps) !== -1) {
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
            }
        }
        _this.current_page = (!_.isUndefined(_this.current_page)) ? _this.current_page : 1;
        _this.users = new App.UserCollection();
        var colspan = "15";
        if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_groups', APPS.enabled_apps) !== -1) {
            colspan = "16";
        }
        $('.js-user-list').html('<tr class="js-loader"><td colspan="' + colspan + '"><span class="cssloader"></span></td></tr>');
        _this.users.url = api_url + 'users.json?page=' + _this.current_page;
        app.navigate('#/' + 'users?page=' + _this.current_page, {
            trigger: false,
            trigger_function: false,
        });
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
                var view = $('#content').html(new App.UserIndexContainerView({
                    filter_count: response.filter_count,
                    roles: response.roles
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
                        total_pages: response._metadata.noOfPages,
                        current_page: _this.current_page,
                        display_max: 4,
                        callback: function(event, page) {
                            event.preventDefault();
                            if (page) {
                                _this.current_page = page;
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
