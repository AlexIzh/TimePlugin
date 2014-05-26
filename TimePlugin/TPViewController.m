//
//  TPViewController.m
//  TimePlugin
//
//  Created by Александр Северьянов on 08.08.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import "TPViewController.h"
#import "LogClient.h"
#import "TimeManagmentObject.h"
#import "MyTreeNode.h"
#import "CustomCell.h"
#import "CustomCellController.h"
#import "IDEKit.h"

@interface MyOutlineView:NSOutlineView
@end
@implementation MyOutlineView
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
@end

@interface TPViewController ()<NSOutlineViewDataSource, NSOutlineViewDelegate> {
    NSMutableArray* treeModel;
	NSMutableDictionary* cellViewControllers;
    NSString *_filePath;
    BOOL        _isLoaded;
}

@end

@implementation TPViewController

- (void)saveNotifications:(NSNotification *)note {
    NSMutableArray *array = [NSMutableArray array];
    for (MyTreeNode *node in treeModel) {
        [array addObject:[node dictionary]];
    }
    [array writeToFile:_filePath atomically:YES];
}

- (void)loadFromFile {
    [treeModel removeAllObjects];
    [cellViewControllers removeAllObjects];
    treeModel = nil;
    cellViewControllers = nil;
    _isLoaded = YES;
    cellViewControllers = [[NSMutableDictionary alloc] init];
    NSArray *arr = [NSArray arrayWithContentsOfFile:_filePath];
    treeModel = [NSMutableArray new];
    for (NSDictionary *dic in arr) {
        [treeModel addObject:[[MyTreeNode alloc] initWithDictionary:dic]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [outlineView setBackgroundColor:[NSColor colorWithCalibratedRed:216/255.f green:221/255.f blue:228/255.f alpha:1.f]];
	
	CustomCell* cell = [[CustomCell alloc] init];
	[cell setEditable:YES];
	
	[[[outlineView tableColumns] objectAtIndex:0] setDataCell:cell];
    
    if (!_isLoaded && _filePath) {
        [self loadFromFile];
        [outlineView reloadData];
    }
}

- (IBAction)addNote:(id)sender {
    MyTreeNode* selectedItem = (MyTreeNode*)[outlineView itemAtRow:[outlineView selectedRow]];
    if (selectedItem) {
        MyTreeNode* child = [[MyTreeNode alloc] initWithName:@"Time Object"];
#if  !__has_feature(objc_arc)
        [child autorelease];
#endif
        if ([selectedItem parent]) {
            child.parent = selectedItem;
            [[selectedItem parent] insertObject:child inChildrenAtIndex:[[[selectedItem parent] children] indexOfObject:selectedItem]+1];
        } else {
            child.parent = selectedItem;
            [selectedItem insertObject:child inChildrenAtIndex:0];
        }
    } else {
        MyTreeNode *node = [[MyTreeNode alloc] initGroupWithName:@"Group"];
#if  !__has_feature(objc_arc)
        [node autorelease];
#endif
        [treeModel addObject:node];
    }
    [outlineView reloadData];
}

- (IBAction)removeNote:(id)sender {
    MyTreeNode* selectedItem = (MyTreeNode*)[outlineView itemAtRow:[outlineView selectedRow]];
    [self removeItems:selectedItem];
    
    if (selectedItem) {
        if ([selectedItem parent]) {
            [[selectedItem parent] removeObjectFromChildren:selectedItem];
        } else {
            [treeModel removeObject:selectedItem];
        }
        [outlineView reloadData];
    }
}

- (IBAction)import:(id)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setCanCreateDirectories:YES];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        NSMutableString *string = [NSMutableString string];
        for (MyTreeNode *node in treeModel) {
            [self stringForNode:node string:&string];
        }
        [string writeToURL:panel.URL atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (IBAction)stopAll:(id)sender {
    for (CustomCellController *c in cellViewControllers.allValues) {
        if (c.playButton.state == NSOnState) {
            c.playButton.state = NSOffState;
            [c.playButton sendAction:@selector(buttonAction:) to:c];
        }
    }
    [self saveNotifications:nil];
}

- (void)stringForNode:(MyTreeNode *)node string:(NSMutableString **)string {
    [*string appendFormat:@"%@\n", [node stringValue]];
    for (MyTreeNode *child in node.children) {
        [self stringForNode:child string:string];
    }
}

- (void)dealloc {
#if  !__has_feature(objc_arc)
    [outlineView release];
    [treeModel release];
    [cellViewControllers release];
    [super dealloc];
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark OutlineView datasource/delegate
-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if (!item) {
		return [treeModel count];
    } else {
		MyTreeNode* node = item;
		return [[node children] count];
	}
}
-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	MyTreeNode* node = item;
	return [node isGroup];
}

- (void)outlineView:(NSOutlineView *)oview willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	// It's at this stage that we can allocate the specific view for the cell
	MyTreeNode* node = item;
	CustomCellController* cellCtrl = [cellViewControllers objectForKey:node];
	if (!cellCtrl) {
		cellCtrl = [[CustomCellController alloc] initWithNode:node];
#if  !__has_feature(objc_arc)
        [cellCtrl autorelease];
#endif
		[cellViewControllers setObject:cellCtrl forKey:node];
	}
	CustomCell* mycell = (CustomCell*)cell;
	if ([mycell isKindOfClass:[CustomCell class]]) {
        [mycell setController: cellCtrl];
    }
}

-(void)hideViewsForItem:(MyTreeNode*)node {
	CustomCellController* cellCtrl = [cellViewControllers objectForKey:node];
	if (cellCtrl) {
		[cellCtrl hideViews];
	}
	for (MyTreeNode* child in node.children) {
		[self hideViewsForItem:child];
    }
}
-(void)removeItems:(MyTreeNode*)node {
	for (MyTreeNode* child in node.children) {
		[self removeItems:child];
    }
	CustomCellController* cellCtrl = [cellViewControllers objectForKey:node];
	if (cellCtrl) {
		[cellCtrl hideViews];
		[cellViewControllers removeObjectForKey:node];
	}
}

-(void)outlineViewItemDidCollapse:(NSNotification*)notif {
	MyTreeNode* node = [[notif userInfo] objectForKey:@"NSObject"];
	for (MyTreeNode* child in node.children) {
		[self hideViewsForItem:child];
    }
}


-(id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	MyTreeNode* node = item;
	return node;
}

-(id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	if (item) {
		MyTreeNode* node = item;
		return [[node children] objectAtIndex:index];
	} else {
		return [treeModel objectAtIndex:index];
    }
}


-(CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
	MyTreeNode* node = item;
	if ([node isGroup]) {
		return 17;
    } else {
		return 19;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn*)col item:(id)item {
	return YES;
}

-(void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	MyTreeNode* node = item;
	node.name = object;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
	if ([[fieldEditor string] length] == 0) {
		return NO;
	} else {
		return YES;
	}
}

#pragma mark - 

- (void)setMainWindow:(NSWindow *)mainWindow {
    if (_mainWindow != mainWindow) {
        _mainWindow = mainWindow;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workspaceWindowDidBecomeMain:) name:NSWindowDidBecomeMainNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveNotifications:) name:@"IDEEditorDocumentDidSaveNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveNotifications:) name:NSWindowWillCloseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveNotifications:) name:NSApplicationDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveNotifications:) name:NSApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveNotifications:) name:NSApplicationDidResignActiveNotification object:nil];
    }
}

- (void)workspaceWindowDidBecomeMain:(NSNotification *)notification {
    // Update currentWorkspacePath property
    if([[notification object] isKindOfClass:NSClassFromString(@"IDEWorkspaceWindow")]) {
        NSWindow *workspaceWindow = (NSWindow *)[notification object];
        if (_mainWindow == workspaceWindow) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeMainNotification object:nil];
            NSWindowController *workspaceWindowController = (NSWindowController *)workspaceWindow.windowController;
            IDEWorkspace *workspace = (IDEWorkspace *)[workspaceWindowController valueForKey:@"_workspace"];
            DVTFilePath *filePath = workspace.filePath;
            NSString *pathString = filePath.pathString;
            
            _filePath = [pathString stringByDeletingLastPathComponent];
            _filePath = [_filePath stringByAppendingPathComponent:@"tpxcplugin.track"];
            if (!_isLoaded) {
                [self loadFromFile];
                [outlineView reloadData];
            }
        }
    }
}

@end
