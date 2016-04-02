/**
 * @fileOverview This file has functions related to user activity view. This view calling from user view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: activity model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * User Activity View
 * @class UserActivityView
 * @constructor
 * @extends Backbone.View
 */
App.UserActivityView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
        emojify.run();
    },
    converter: new showdown.Converter(),
    template: JST['templates/user_activity'],
    className: 'list-group-item-text',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-undo2': 'undo_all'
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
            activity: this.model,
            type: this.type,
            converter: this.converter
        }));
        this.showTooltip();
        return this;
    },
    /**
     * undo_all()
     * revert changes to the previous version
     * @param NULL
     * @return false
     */
    undo_all: function(e) {
        var self = this;
        e.preventDefault();
        this.model.url = api_url + 'activities/undo/' + this.model.id + '.json';
        this.model.save({}, {
            patch: true,
            success: function(model, response) {
                self.flash('danger', i18next.t('Undo Succeed'));
                emojify.run();
            }
        });
        return false;
    }
});
