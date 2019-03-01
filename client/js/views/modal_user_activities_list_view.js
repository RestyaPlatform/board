/**
 * @fileOverview This file has functions related to modal user activities list view. This view calling from modal user actions view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Modal User Activities List View
 * @class ModalUserActivitiesListView
 * @constructor
 * @extends Backbone.View
 */
App.ModalUserActivitiesListView = Backbone.View.extend({
    id: 'base-modal',
    className: '',
    template: JST['templates/modal_user_activities_list_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click #js-admin-activites-load-more': 'loadActivities',
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.user_id = options.user_id;
        this.is_from = options.is_from;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        _(this).bindAll('show', 'teardown');
    },
    teardown: function() {
        this.$el.data('modal', null);
        this.remove();
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
            list: this.model
        }));
        this.getListing();
        this.$el.modal({
            show: true,
            backdrop: false
        });
        this.showTooltip();
        return this;
    },
    /** 
     * getListing()
     * get settings
     * @return false
     */
    getListing: function() {
        var self = this;
        var view_user_activities = this.$('#js-list-user-activities-list');
        view_user_activities.html('');
        var activities = new App.ActivityCollection();
        activities.url = api_url + 'users/' + this.user_id + '/activities.json?board_id=' + this.model.attributes.board_id;
        activities.fetch({
            success: function(model, response) {
                if (!_.isEmpty(activities.models)) {
                    var last_activity = _.min(activities.models, function(activity) {
                        return activity.id;
                    });
                    self.last_activity_id = last_activity.id;
                    self.model.set('activity_count', response._metadata.total_records);
                    self.renderActivitiesCollection(activities);
                } else {
                    var view = new App.ActivityView({
                        model: null,
                    });
                    view_user_activities.html(view.render().el);
                }
            }
        });
    },
    /**
     * show()
     * display list attachment
     */
    show: function() {
        this.render();
        this.$el.find('#modalUserActivitiesListView').modal('show');
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
     * loadActivities()
     * display load Activities
     */
    loadActivities: function() {
        //e.preventDefault();
        var self = this;
        var query_string = (this.last_activity_id !== 0) ? '?last_activity_id=' + this.last_activity_id : '';
        var activities = new App.ActivityCollection();
        activities.url = api_url + 'users/' + this.user_id + '/activities.json' + query_string + '&board_id=' + this.model.attributes.board_id;
        activities.fetch({
            cache: false,
            success: function(user, response) {
                if (!_.isEmpty(activities) && !_.isEmpty(activities.models)) {
                    var last_activity = _.min(activities.models, function(activity) {
                        return activity.id;
                    });
                    self.last_activity_id = last_activity.id;
                    self.renderActivitiesCollection(activities);
                }
            }
        });
    },
    /**
     * renderUserActivitiesCollection()
     * render activities
     */
    renderActivitiesCollection: function(activities) {
        var self = this;
        var view_user_activities = this.$('#js-list-user-activities-list');
        view_user_activities.html('');
        if (!_.isEmpty(activities)) {
            if (self.model.attributes.activity_count != PAGING_COUNT && activities.models.length >= PAGING_COUNT) {
                self.$('#js-admin-activites-load-more').removeClass('hide');
            }
            for (var i = 0; i < activities.models.length; i++) {
                var activity = activities.models[i];
                activity.from_footer = true;
                var view = new App.ActivityView({
                    model: activity,
                    is_from: self.is_from
                });
                view_user_activities.append(view.render().el);
            }
        }
    }
});
