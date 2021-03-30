/**
 * @fileOverview This file has functions related to user index container view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * PushNotifictaionContainerView
 * @class PushNotifictaionContainerView
 * @constructor
 * @extends Backbone.View
 */
App.PushNotifictaionContainerView = Backbone.View.extend({
    template: JST['templates/push_notifications_index_container'],
    tag: 'section',
    className: 'clearfix row',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-filter': 'filterUser'
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.sortField = options.sortField;
        this.filter_count = options.filter_count;
        this.roles = options.roles;
        this.current_param = options.current_param;
        this.sortDirection = options.sortDirection;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
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
        this.$el.html(this.template({
            filter_count: this.filter_count,
            roles: this.roles,
            'current_param': this.current_param
        }));

        this.showTooltip();
        return this;
    },
    /**
     * filterUser()
     * @param NULL
     * @return object
     *
     */
    filterUser: function(e) {
        var _this = this;
        _this.current_page = (!_.isUndefined(_this.current_page)) ? _this.current_page : 1;
        _this.filterField = (!_.isUndefined(e)) ? $(e.currentTarget).data('filter') : _this.filterField;
        var users = new App.UserCollection();
        var colspan = "15";
        changeTitle(i18next.t('Users') + ' - ' + $(e.currentTarget).attr('title'));
        $('.js-pushNotification-list').html('<tr class="js-loader"><td colspan="' + colspan + '"><span class="cssloader"></span></td></tr>');
        users.url = api_url + 'user_push_tokens.json?page=' + _this.current_page + '&filter=' + _this.filterField;
        app.navigate('#/' + 'push_devices?page=' + _this.current_page + '&filter=' + _this.filterField, {
            trigger: false,
            trigger_function: false,
        });
        users.fetch({
            cache: false,
            abortPending: true,
            success: function(users, response) {
                $('.js-pushNotification-list').html('');
                if (users.length !== 0) {
                    users.each(function(user) {
                        user.roles = response.roles;
                        $('.js-pushNotification-list').append(new App.PushNotifictaionsIndex({
                            model: user
                        }).el);
                    });
                } else {
                    $('.js-pushNotification-list').html('<tr><td class="text-center" colspan="' + colspan + '">No record found</td></tr>');
                }
                $('.js-filter-list').children().removeClass('active');
                if (!_.isUndefined(e)) {
                    $(e.currentTarget).parent().addClass('active');
                }
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
                                if (!_.isUndefined(_this.filterField) && _this.filterField !== null && _this.filterField !== 'all') {
                                    app.navigate('#/' + 'push_devices?page=' + page + '&filter=' + _this.filterField, {
                                        trigger: true,
                                        trigger_function: true,
                                    });
                                } else {
                                    _this.current_page = page;
                                    app.navigate('#/' + 'push_devices?page=' + page, {
                                        trigger: true,
                                        trigger_function: true,
                                    });
                                }
                            }
                        }
                    });
                }
            }
        });
    }
});
