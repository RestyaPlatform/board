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
    }
});
