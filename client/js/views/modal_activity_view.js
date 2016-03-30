/**
 * @fileOverview This file has functions related to modal activity view. This view calling from footer view, organization and user index view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: activity model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ModalActivity View
 * @class ModalActivityView
 * @constructor
 * @extends Backbone.View
 */
App.ModalActivityView = Backbone.View.extend({
    id: 'base-modal',
    className: '',
    template: JST['templates/modal_activity_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click .js-load-more': 'loadMore',
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.type = options.type;
        this.organization_id = options.organization_id;
        this.last_activity_id = 0;
        _(this).bindAll('show', 'teardown');
        this.activities = new App.ActivityCollection();
        var query_string = '';
        if (!_.isUndefined(this.organization_id)) {
            query_string += '&organization_id=' + this.organization_id;
        }
        if (this.type === 'board') {
            this.activities.url = api_url + 'boards/' + authuser.board_id + '/activities.json?type=all';
        } else if (this.type === 'user_listing') {
            this.activities.url = api_url + 'users/' + this.model.attributes.id + '/activities.json?type=all' + query_string;
        } else if (this.type === 'org_user_listing') {
            this.activities.url = api_url + 'users/' + this.model + '/activities.json?type=all' + query_string;
        } else {
            this.activities.url = api_url + 'users/' + authuser.user.id + '/activities.json?type=all' + query_string;
        }
    },
    teardown: function() {},
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            list: this.model,
            type: this.type
        }));

        this.$el.modal({
            show: true,
            backdrop: false
        });
        this.showTooltip();
        return this;
    },
    /**
     * show()
     * display list attachment
     */
    show: function() {
        var self = this;
        self.render();
        this.activities.fetch({
            success: function() {
                self.renderActivitiesCollection(false);
                if (self.activities.models.length > 0) {
                    self.$el.find('.js-load-more').removeClass('hide');
                } else {
                    self.$el.find('.js-load-more').addClass('hide');
                }
            }
        });
        this.$el.find('#modalActivityView').modal('show');
    },
    /**
     * closePopup()
     * close opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    },
    /**
     * renderActivitiesCollection()
     * render Activity
     */
    renderActivitiesCollection: function(is_load_more) {
        var self = this;
        var last_activity = _.min(this.activities.models, function(activity) {
            return activity.id;
        });
        this.last_activity_id = last_activity.id;
        this.activities.each(function(activity) {
            var view = new App.ActivityView({
                model: activity,
                type: 'all'
            });
            self.$el.find('#js-activities-list').append(view.render().el).find('.timeago').timeago();
        });
        if (!is_load_more && this.activities.models.length === 0) {
            var view = new App.ActivityView({
                model: null,
                type: 'all'
            });
            self.$el.find('#js-activities-list').html(view.render().el);
        }
    },
    /**
     * loadMore()
     * load more
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    loadMore: function(e) {
        var self = this;
        var query_string = '&last_activity_id=' + this.last_activity_id;
        if (!_.isUndefined(this.last_activity_id)) {
            if (!_.isUndefined(this.organization_id)) {
                query_string += '&organization_id=' + this.organization_id;
            }
            if (this.type === 'board') {
                this.activities.url = api_url + 'boards/' + authuser.board_id + '/activities.json?type=all' + query_string;
            } else if (this.type === 'user_listing') {
                this.activities.url = api_url + 'users/' + this.model.attributes.id + '/activities.json?type=profile' + query_string;
            } else if (this.type === 'org_user_listing') {
                this.activities.url = api_url + 'users/' + this.model + '/activities.json?type=profile' + query_string;
            } else {
                this.activities.url = api_url + 'users/' + authuser.user.id + '/activities.json?type=profile' + query_string;
            }
        } else {
            $('.js-load-more').hide();
        }

        this.activities.fetch({
            success: function() {
                self.renderActivitiesCollection(true);
                if (self.activities.models.length > 0) {
                    self.$el.find('.js-load-more').removeClass('hide');
                } else {
                    self.$el.find('.js-load-more').addClass('hide');
                }
            }
        });

        return false;
    }
});
