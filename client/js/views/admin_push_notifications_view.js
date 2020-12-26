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
 * Admin Push Notifictaion View
 * @class AdminPushNotifictaionView
 * @constructor
 * @extends Backbone.View
 */
App.AdminPushNotifictaionView = Backbone.View.extend({
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
        _this.current_page = (!_.isUndefined(_this.current_page)) ? _this.current_page : 1;
        _this.pagination = (!_.isUndefined(_this.pagination)) ? _this.pagination : 1;
        _this.users = new App.UserCollection();
        $('.js-user-list').html('<tr class="js-loader"><td colspan="15"><span class="cssloader"></span></td></tr>');
        _this.users.url = api_url + 'user_push_tokens.json?page=' + _this.current_page;
        _this.users.fetch({
            cache: false,
            abortPending: true,
            success: function(users, response) {
                _this.headerView = new App.HeaderView({
                    model: authuser
                });
                $('#header').html(_this.headerView.el);
                $('#js-navbar-default').remove();
                var view = $('#content').html(new App.PushNotifictaionContainerView({
                    filter_count: response.filter_count,
                    roles: response.roles,
                    'current_param': _this.current_param
                }).el);
                users.each(function(user) {
                    $('.js-pushNotification-list').append(new App.PushNotifictaionsIndex({
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
                                } else {
                                    _this.current_page = page;
                                }
                                app.navigate('#/' + 'push_devices?page=' + page, {
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
    }
});
