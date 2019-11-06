/**
 * @fileOverview This file has functions related to organizations list header view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organizations collection.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Header View
 * @class HeaderView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationsListsHeaderView = Backbone.View.extend({
    className: '',
    template: JST['templates/organizations_lists_header'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-sort-by': 'sortBy'
    },

    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        this.sortField = 'id';
        this.sortDirection = 'desc';
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
            user: this.model,
            type: this.type
        }));
        this.renderList();
        this.showTooltip();
        return this;
    },
    renderList: function() {
        $('#content').html(new App.OrganizationsListsView({
            model: this.model,
            sortField: this.sortField,
            sortDirection: this.sortDirection
        }).el);
    },
    sortBy: function(e) {
        e.preventDefault();
        var sortField = $(e.currentTarget).data('field');
        if ($('.js-sort-by-organizations').hasClass('active')) {
            $('.js-sort-by-organizations').removeClass('active');
        }
        $('.js-sort-down-organizations').remove();
        $('.js-sort-up-organizations').remove();
        if (this.sortDirection === 'desc') {
            if (this.sortField !== 'id') {
                $(e.target).parent().addClass('active');
                $(e.target).html('<i class="icon icon-arrow-up js-sort-up-organizations"></i>' + i18next.t($(e.target).text()));
                this.sortDirection = 'asc';
            } else {
                $(e.target).parent().addClass('active');
                $(e.target).html('<i class="icon icon-arrow-down js-sort-down-organizations"></i>' + i18next.t($(e.target).text()));
            }
        } else {
            $(e.target).parent().addClass('active');
            $(e.target).html('<i class="icon icon-arrow-down js-sort-down-organizations"></i>' + i18next.t($(e.target).text()));
            this.sortDirection = 'desc';
        }
        this.sortField = sortField;
        this.renderList();
    }
});
