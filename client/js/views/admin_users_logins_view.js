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
 * @class AdminUsersLoginView
 * @constructor
 * @extends Backbone.View
 */
App.AdminUserLoginView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.current_page = (!_.isUndefined(options.page) && options.page !== null) ? options.page : 1;
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
        _this.current_page = (!_.isUndefined(_this.current_page)) ? _this.current_page : 1;
        _this.users = new App.UserCollection();
        $('.js-user-list').html('<tr class="js-loader"><td colspan="15"><span class="cssloader"></span></td></tr>');
        _this.users.url = api_url + 'user_logins.json?page=' + _this.current_page;
        _this.users.fetch({
            cache: false,
            abortPending: true,
            success: function(users, response) {
                _this.headerView = new App.HeaderView({
                    model: authuser
                });
                $('#header').html(_this.headerView.el);
                $('#js-navbar-default').remove();
                var view = $('#content').html(new App.UserLoginsContainerView({
                    filter_count: response.filter_count,
                    roles: response.roles
                }).el);
                users.each(function(user) {
                    user.roles = response.roles;
                    $('.js-userlogin-list').append(new App.UserLoginsIndex({
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
                                _this.current_page = page;
                                app.navigate('#/' + 'user_logins?page=' + page, {
                                    trigger: true,
                                    trigger_function: true,
                                });
                            }
                        }
                    });
                }
            }
        });
    }
});
