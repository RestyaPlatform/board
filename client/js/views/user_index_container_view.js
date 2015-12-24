/**
 * @fileOverview This file has functions related to user index container view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * UserIndexContainer View
 * @class UserIndexContainerView
 * @constructor
 * @extends Backbone.View
 */
App.UserIndexContainerView = Backbone.View.extend({
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'change .js-more-action-user': 'usersMoreActions',
        'click .js-sort': 'sortUser',

    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.sortField = options.sortField;
        this.sortDirection = options.sortDirection;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/user_index_container'],
    tag: 'section',
    className: 'clearfix row',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            user: this.model
        }));
        if (!_.isUndefined(this.sortField)) {
            this.renderUserCollection();
        }
        this.showTooltip();
        return this;
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    renderUserCollection: function() {
        var view = this.$el.find('.js-user-list');
        this.model.setSortField(this.sortField, this.sortDirection);
        this.model.sort();
        this.model.each(function(user) {
            view.append(new App.UserIndex({
                model: user
            }).el);
        });
        return this;
    },
    /**
     * sortUser()
     * @param NULL
     * @return object
     *
     */
    sortUser: function(e) {
        var _this = this;
        _this.current_page = (!_.isUndefined(_this.current_page)) ? _this.current_page : 1;
        _this.sortField = (!_.isUndefined(e)) ? $(e.currentTarget).data('field') : _this.sortField;
        _this.sortDirection = (!_.isUndefined(e)) ? $(e.currentTarget).data('direction') : _this.sortDirection;
        var users = new App.UserCollection();
        users.setSortField(_this.sortField, _this.sortDirection);
        users.url = api_url + 'users.json?page=' + _this.current_page + '&sort=' + _this.sortField + '&direction=' + _this.sortDirection;
        if (!_.isUndefined(e)) {
            if ($(e.currentTarget).data('direction') == 'desc') {
                $(e.currentTarget).data('direction', 'asc');
                $('span.icon-caret-up').addClass('hide');
                $('span.icon-caret-down').addClass('hide');
                $(e.currentTarget).find('span').removeClass('hide');
                $(e.currentTarget).siblings('span').removeClass('hide');
                $(e.currentTarget).find('span').removeClass('icon-caret-up').addClass('icon-caret-down');
                $(e.currentTarget).siblings('span').removeClass('icon-caret-up').addClass('icon-caret-down');
            } else {
                $(e.currentTarget).data('direction', 'desc');
                $('span.icon-caret-up').addClass('hide');
                $('span.icon-caret-down').addClass('hide');
                $(e.currentTarget).find('span').removeClass('hide');
                $(e.currentTarget).siblings('span').removeClass('hide');
                $(e.currentTarget).find('span').removeClass('icon-caret-down').addClass('icon-caret-up');
                $(e.currentTarget).siblings('span').removeClass('icon-caret-down').addClass('icon-caret-up');
            }
        }
        $('.js-user-list').html('');
        users.fetch({
            cache: false,
            abortPending: true,
            success: function(users, response) {
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
                            _this.sortUser();
                        }
                    }
                });
            }
        });
    },
    /**
     * usersMoreActions()
     * @param NULL
     * @return object
     *
     */
    usersMoreActions: function(e) {
        var self = this;
        if (_.isUndefined($('.js-checkbox-list:checked').val())) {
            alert('Please select atleast one record!');
            return false;
        } else {
            if (window.confirm('Are you sure you want to do this action?')) {
                var User = Backbone.Model.extend({});
                var Users = Backbone.BatchCollection.extend({
                    model: User,
                    url: api_url + 'users/bulk_action.json?token=' + api_token
                });
                var users = new Users();
                var data = {};
                $(':checkbox:checked').each(function(i) {
                    data[i] = {};
                    data[i].user_id = $(this).val();
                });
                data.action_id = {};
                data.action_id.action_id = $("#js-more-action option:selected").val();
                users.add(data, {
                    silent: true
                });
                users.save({
                    'success': function(response) {
                        if (!_.isEmpty(response.success)) {
                            self.flash('success', response.success);
                            app.navigate('#/users', {
                                trigger: true,
                            });
                        }
                    }
                });
            }
        }
    }
});
