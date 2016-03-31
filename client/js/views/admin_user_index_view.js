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
        _this.current_page = (!_.isUndefined(_this.current_page)) ? _this.current_page : 1;
        _this.users = new App.UserCollection();
        $('.js-user-list').html('<tr class="js-loader"><td colspan="15"><span class="cssloader"></span></td></tr>');
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
                    $('.js-user-list').append(new App.UserIndex({
                        model: user
                    }).el);
                });
                $('.js-user-list').find('.timeago').timeago();
                $('.pagination-boxes').unbind();
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
        });
    }
});
