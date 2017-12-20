/**
 * @fileOverview This file has functions related to edit activity form view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: activitiy model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * EditActivityForm View
 * @class EditActivityFormView
 * @constructor
 * @extends Backbone.View
 */
App.EditActivityFormView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    converter: new showdown.Converter({
        extensions: ['targetblank', 'xssfilter', 'codehighlight']
    }),
    template: JST['templates/edit_activity_form'],
    tagName: 'form',
    className: 'js-edit-comment',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-show-editComment': 'showEditComment',
        'click .js-preview-editComment': 'previewEditComment'
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.converter.setFlavor('github');
        this.$el.html(this.template({
            activity: this.model
        }));
        this.showTooltip();
        return this;
    },
    /**
     * showEditComment()
     * show textarea for comment
     * @param e
     * @type Object(DOM event)
     *
     */
    showEditComment: function(e) {
        e.preventDefault();
        var target = e.currentTarget;
        var commentId = $(target).attr("data-id");
        if (!$('.show-editComment-' + commentId).hasClass('active')) {
            $('.show-editComment-' + commentId).addClass('active');
            $('.preview-editComment-' + commentId).removeClass('active');
        }
        $(target).parents('.js-edit-comment').find('textarea.js-inputComment').removeClass('hide').addClass('show');
        $(target).parents('.js-edit-comment').find('.js-card-editComment-preview-panel').removeClass('show').addClass('hide');
    },
    /**
     * previewEditComment()
     * show html formatted comment
     * @param e
     * @type Object(DOM event)
     *
     */
    previewEditComment: function(e) {
        e.preventDefault();
        var target = e.currentTarget;
        var commentId = $(target).attr("data-id");
        $('.show-editComment-' + commentId).removeClass('active');
        $('.preview-editComment-' + commentId).addClass('active');
        if ($(target).parents('.js-edit-comment').find('textarea.js-inputComment').hasClass('show')) {
            $(target).parents('.js-edit-comment').find('textarea.js-inputComment').removeClass('show').addClass('hide');
        } else {
            $(target).parents('.js-edit-comment').find('textarea.js-inputComment').addClass('hide');
        }
        var value = $(target).parents('.js-edit-comment').find('textarea.js-inputComment').val();
        if (value !== "") {
            $(target).parents('.js-edit-comment').find('.js-card-editComment-preview').html(this.converter.makeHtml(value));
        } else {
            $(target).parents('.js-edit-comment').find('.js-card-editComment-preview').html("<p>Nothing to preview</p>");
        }
        $(target).parents('.js-edit-comment').find('.js-card-editComment-preview-panel').removeClass('hide').addClass('show');
    }
});
