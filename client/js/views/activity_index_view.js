/**
 * @fileOverview This file has functions related to activity index view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined
 */
if (typeof App === 'undefined') {
    App = {};
}
App.ActivityIndexView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.id = options.id;
        this.getListing();
        this.render();
        this.last_activity_id = 0;
    },
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click #js-admin-activites-load-more': 'loadActivities',
    },
    template: JST['templates/activity_index'],
    converter: new showdown.Converter(),
    /** 
     * getListing()
     * get settings
     * @return false
     */
    getListing: function() {
        self = this;
        if (_.isUndefined(this.id)) {
            this.id = 1;
        }
        var activities = new App.ActivityCollection();
        activities.url = api_url + 'activities.json';
        activities.fetch({
            cache: false,
            abortPending: true,
            success: function(collections, response) {
                if (!_.isEmpty(activities.models)) {
                    self.renderActivitiesCollection(activities);
                    var last_activity = _.min(activities.models, function(activity) {
                        return activity.id;
                    });
                    self.last_activity_id = last_activity.id;
                    self.$('#js-admin-activites-load-more').removeClass('hide');
                } else {
                    var view_activity = this.$('#js-admin-activity-list');
                    var view = new App.AdminActivityIndexView({
                        model: null,
                    });
                    view_activity.html(view.el);
                }

            }
        });
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function(collections) {
        this.$el.html(this.template({
            type: 'all',
        }));

        this.$('.timeago').timeago();
        $('.js-admin-activity-menu').addClass('active');
        $('.js-admin-email-menu, .js-admin-user-menu, .js-admin-role-menu, .js-admin-setting-menu, .js-admin-board-menu').removeClass('active');
        return this;
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
        activities.url = api_url + 'activities.json' + query_string;
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
     * renderActivitiesCollection()
     * display card activities
     */
    renderActivitiesCollection: function(activities) {
        $('.js-admin-activity-menu').addClass('active');
        $('.js-admin-email-menu, .js-admin-user-menu, .js-admin-role-menu, .js-admin-setting-menu, .js-admin-board-menu').removeClass('active');
        var self = this;
        var view_activity = this.$('#js-admin-activity-list');
        if (!_.isEmpty(activities)) {
            for (var i = 0; i < activities.models.length; i++) {
                var activity = activities.models[i];
                var view = new App.AdminActivityIndexView({
                    model: activity,
                });
                view_activity.append(view.el).find('.timeago').timeago();
            }
        }
    }
});
